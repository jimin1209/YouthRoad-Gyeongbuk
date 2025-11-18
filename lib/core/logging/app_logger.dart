import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'logging_config.dart';
import 'network_event.dart';

typedef FlutterAppRunner = FutureOr<void> Function();

class AppLogger {
  const AppLogger._();

  static bool _crashlyticsReady = false;

  /// Initializes Crashlytics and Sentry (if requested) around the Flutter app
  /// entry point so that the first errors are captured with context.
  static Future<void> bootstrap(FlutterAppRunner appRunner) async {
    if (LoggingConfig.useSentry) {
      await SentryFlutter.init(
        (options) {
          if (LoggingConfig.sentryDsn.isNotEmpty) {
            options.dsn = LoggingConfig.sentryDsn;
          }
          options.tracesSampleRate = 0.25;
          options.enableAutoPerformanceTracing = false;
        },
        appRunner: () => _runWithCrashlytics(appRunner),
      );
      return;
    }

    await _runWithCrashlytics(appRunner);
  }

  static Future<void> _runWithCrashlytics(FlutterAppRunner appRunner) async {
    if (LoggingConfig.useCrashlytics) {
      await Firebase.initializeApp();
      _crashlyticsReady = true;
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    await appRunner();
  }

  /// Records a network breadcrumb and optionally reports an error to Sentry or
  /// Crashlytics, while still printing to stdout in debug mode.
  static Future<void> recordNetworkEvent(NetworkLogEvent event) async {
    final payload = <String, dynamic>{
      'method': event.method,
      'uri': event.uri.toString(),
      'statusCode': event.statusCode,
      'durationMs': event.duration?.inMilliseconds,
      'timestamp': event.timestamp.toIso8601String(),
      'error': event.errorMessage,
      'requestBody': event.requestBody,
      'responseBody': event.responseBody,
      ...event.extra,
    };

    if (kDebugMode) {
      log('[network] ${event.method} ${event.uri} => ${event.statusCode ?? 'ERR'}',
          name: 'AppLogger', error: event.errorMessage, level: 800);
    }

    if (LoggingConfig.useSentry) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          category: 'http',
          type: 'http',
          data: payload,
          message: '${event.method} ${event.uri}',
          level: event.isError ? SentryLevel.error : SentryLevel.info,
        ),
      );

      if (event.isError) {
        await Sentry.captureMessage(
          'HTTP ${event.statusCode ?? 'ERR'} ${event.uri}',
          level: SentryLevel.error,
          withScope: (scope) {
            scope.setContexts('network', payload);
            if (event.errorMessage != null) {
              scope.setExtra('message', event.errorMessage!);
            }
          },
        );
      }
    }

    if (LoggingConfig.useCrashlytics && _crashlyticsReady) {
      await FirebaseCrashlytics.instance
          .log('[network] ${event.method} ${event.uri}');
      if (event.isError) {
        await FirebaseCrashlytics.instance.recordError(
          event.errorMessage ?? 'Network error',
          StackTrace.current,
          reason: 'HTTP ${event.statusCode ?? 'ERR'} ${event.uri}',
          information: [payload],
          fatal: false,
        );
      }
    }
  }
}
