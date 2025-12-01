import 'package:flutter/foundation.dart';

import '../logging/app_logger.dart';
import 'app_exception.dart';

class ErrorReporter {
  ErrorReporter._();

  static final ErrorReporter instance = ErrorReporter._();

  void record(
    Object error, {
    StackTrace? stackTrace,
    String? hint,
  }) {
    final resolvedStack = stackTrace ?? StackTrace.current;
    final appException = _toAppException(error, resolvedStack);
    final prefix = hint != null ? '[$hint] ' : '';
    AppLogger.error(
      '$prefix${appException.debugMessage}',
      error: appException,
      stackTrace: resolvedStack,
    );
  }

  void captureFlutterError(FlutterErrorDetails details) {
    record(
      details.exception,
      stackTrace: details.stack,
      hint: details.context?.toDescription(),
    );
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  }

  AppException _toAppException(Object error, StackTrace stackTrace) {
    if (error is AppException) {
      return error;
    }
    return UnexpectedException(
      debugMessage: error.toString(),
      stackTrace: stackTrace,
      cause: error,
    );
  }
}
