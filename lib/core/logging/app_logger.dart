import 'package:flutter/foundation.dart';

import '../../devtools/devtools_provider.dart';
import 'app_log_level.dart';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void logInfo(String message, {String? tag}) {
    _log(message, AppLogLevel.info, tag: tag);
  }

  static void logWarning(String message, {String? tag}) {
    _log(message, AppLogLevel.warning, tag: tag);
  }

  static void logError(String message, {String? tag, Object? error}) {
    final errorSuffix = error != null ? ' | error=$error' : '';
    _log(message + errorSuffix, AppLogLevel.error, tag: tag);
  }

  static void _log(String message, AppLogLevel level, {String? tag}) {
    final label = switch (level) {
      AppLogLevel.info => 'INFO',
      AppLogLevel.warning => 'WARN',
      AppLogLevel.error => 'ERROR',
    };
    final prefix = tag != null ? '[$tag]' : '';
    final formatted = '[AppLogger][$label] $prefix$message';

    if (!kReleaseMode) {
      debugPrint(formatted);
      DevtoolsBinding.instance.addLog(level, formatted);
    } else {
      debugPrint(formatted);
  static void info(String message, {String tag = 'App'}) {
    _log('INFO', message, tag: tag);
  }

  static void warning(String message, {String tag = 'App'}) {
    _log('WARN', message, tag: tag);
  }

  static void error(
    String message, {
    String tag = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log('ERROR', message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
    String level,
    String message, {
    required String tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final formatted = '[$tag][$level] $message';
    if (kDebugMode) {
      debugPrint(formatted);
      if (error != null) {
        debugPrint('[$tag][$level][error] $error');
      }
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
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
