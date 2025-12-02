import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

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
