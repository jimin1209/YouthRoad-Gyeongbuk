import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/di.dart';
import '../../core/logging/app_log_level.dart';
import '../../debug/debug_log_collector.dart';
import '../../debug/debug_provider_tracker.dart';
import '../../devtools/devtools_provider.dart';
import '../providers/app_providers.dart';

typedef AppBuilder = Widget Function();

Future<void> bootstrap({
  required AppBuilder builder,
  List<Override> overrides = const [],
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    (previousOnError ?? FlutterError.presentError).call(details);
    DevtoolsBinding.instance.addLog(
      AppLogLevel.error,
      '[FlutterError] ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
    );
  };
  final prefs = await SharedPreferences.getInstance();

  final observers = <ProviderObserver>[];
  if (kDebugMode) {
    final originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) {
        DebugLogCollector.instance.add(message);
        DevtoolsBinding.instance.addLog(AppLogLevel.debug, message);
      }
      originalDebugPrint(message, wrapWidth: wrapWidth);
    };
    observers.add(DebugProviderObserver());
  }

  runZonedGuarded(
    () {
      runApp(
        ProviderScope(
          overrides: [
            ...buildAppOverrides(sharedPreferences: prefs),
            ...overrides,
          ],
          observers: observers,
          child: builder(),
        ),
      );
    },
    (error, stack) {
      if (kDebugMode) {
        DebugLogCollector.instance.add('[ZoneError] $error');
      }
      DevtoolsBinding.instance.addLog(
        AppLogLevel.error,
        '[ZoneError] $error',
        error: error,
        stackTrace: stack,
      );
    },
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        if (kDebugMode) {
          DebugLogCollector.instance.add(line);
          DevtoolsBinding.instance.addLog(AppLogLevel.debug, line);
        }
        parent.print(zone, line);
      },
    ),
  );
}
