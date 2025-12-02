import 'dart:async';

import 'package:dio/dio.dart';

class RetryPolicy {
  const RetryPolicy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffFactor = 2.0,
  }) : assert(maxAttempts > 0, 'maxAttempts must be greater than zero');

  final int maxAttempts;
  final Duration initialDelay;
  final double backoffFactor;

  Future<T> execute<T>(Future<T> Function(int attempt) action) async {
    Object? lastError;
    StackTrace? lastStack;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await action(attempt);
      } on Object catch (error, stackTrace) {
        lastError = error;
        lastStack = stackTrace;
        final shouldRetry = this.shouldRetry(error) && attempt < maxAttempts;
        if (!shouldRetry) {
          return Future<T>.error(error, stackTrace);
        }
        await Future<void>.delayed(delayFor(attempt));
      }
    }
    return Future<T>.error(lastError!, lastStack!);
  }

  bool shouldRetry(Object error) {
    if (error is! DioException) {
      return false;
    }

    final statusCode = error.response?.statusCode ?? 0;
    final isServerError = statusCode >= 500 && statusCode < 600;
    final isTimeout = error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
    final isOffline = error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown;

    return isServerError || isTimeout || isOffline;
  }

  Duration delayFor(int attempt) {
    if (attempt <= 0) return initialDelay;
    final double factor = backoffFactor <= 0 ? 1 : backoffFactor;
    final multiplier = factor == 1 ? attempt - 1 : (factor).pow(attempt - 1);
    final delayMillis = initialDelay.inMilliseconds * multiplier;
    return Duration(milliseconds: delayMillis.toInt());
  }
}

extension _NumPow on double {
  double pow(int exponent) {
    var result = 1.0;
    for (var i = 0; i < exponent; i++) {
      result *= this;
    }
    return result;
  }
}
