import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../../devtools/devtools_provider.dart';
import 'app_log_level.dart';

class AppLogger {
  const AppLogger._();

  static void info(String message, {String tag = 'App'}) {
    _log(message, AppLogLevel.info, tag: tag);
  }

  static void warning(String message, {String tag = 'App'}) {
    _log(message, AppLogLevel.warning, tag: tag);
  }

  static void debug(String message, {String tag = 'App'}) {
    _log(message, AppLogLevel.debug, tag: tag);
  }

  static void error(
    String message, {
    String tag = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(message, AppLogLevel.error, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
    String message,
    AppLogLevel level, {
    required String tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final label = switch (level) {
      AppLogLevel.debug => 'DEBUG',
      AppLogLevel.info => 'INFO',
      AppLogLevel.warning => 'WARN',
      AppLogLevel.error => 'ERROR',
    };
    final formatted = '[$tag][$label] $message';

    if (!kReleaseMode) {
      debugPrintSynchronously(formatted);
      if (error != null) {
        debugPrintSynchronously('[$tag][$label][error] $error');
      }
      if (stackTrace != null) {
        debugPrintSynchronously(stackTrace.toString());
      }
      DevtoolsBinding.instance.addLog(
        level,
        formatted,
        error: error,
        stackTrace: stackTrace,
        extra: {'tag': tag},
      );
    } else {
      developer.log(
        formatted,
        name: tag,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
