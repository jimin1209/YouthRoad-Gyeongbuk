import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/app_exception.dart';
import '../error/error_reporter.dart';
import '../logging/app_logger.dart';
import 'network_result.dart';
import 'retry_policy.dart';
import '../devtools/debug_network_logger.dart';

Dio createAppDio() {
  final dio = Dio();

  if (!kReleaseMode) {
    DebugNetworkLogger.instance.attachTo(dio);
    dio.interceptors.add(_DevtoolsNetworkInterceptor());
  }

  return dio;
}

class _DevtoolsNetworkInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['_startTime'] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _record(response.requestOptions, response.statusCode, null);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _record(err.requestOptions, err.response?.statusCode, err);
    super.onError(err, handler);
  }

  void _record(RequestOptions options, int? statusCode, DioException? error) {
    final start = options.extra['_startTime'] as DateTime?;
    final duration = start != null ? DateTime.now().difference(start) : null;

    DevtoolsBinding.instance.addNetwork(
      NetworkEvent(
        method: options.method,
        path: options.uri.path,
        statusCode: statusCode,
        duration: duration,
        error: error,
      ),
    );
  }
}

class AppDio {
  AppDio({
    BaseOptions? options,
    RetryPolicy? retryPolicy,
    ErrorReporter? errorReporter,
  })  : dio = Dio(
          options ??
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 15),
                sendTimeout: const Duration(seconds: 10),
                receiveDataWhenStatusError: true,
              ),
        ),
        _retryPolicy = retryPolicy ?? const RetryPolicy(),
        _errorReporter = errorReporter ?? ErrorReporter.instance {
    DebugNetworkLogger.instance.attachTo(dio);
  }

  final Dio dio;
  final RetryPolicy _retryPolicy;
  final ErrorReporter _errorReporter;

  Future<NetworkResult<T>> execute<T>(
    Future<Response<T>> Function(Dio dio) request, {
    String? description,
  }) async {
    try {
      final response = await _retryPolicy.execute<Response<T>>((_) async {
        return request(dio);
      });

      final data = response.data;
      if (data is T) {
        return NetworkSuccess<T>(data);
      }

      final exception = UnexpectedException(
        debugMessage:
            'Invalid response type: expected $T but received ${data.runtimeType}',
        stackTrace: StackTrace.current,
      );
      _errorReporter.record(exception);
      return NetworkFailure<T>(exception);
    } on DioException catch (error, stackTrace) {
      final appException = _mapDioException(error, stackTrace, description);
      _errorReporter.record(appException, stackTrace: stackTrace);
      return NetworkFailure<T>(appException);
    } catch (error, stackTrace) {
      final appException = UnexpectedException(
        debugMessage: error.toString(),
        stackTrace: stackTrace,
        cause: error,
      );
      _errorReporter.record(appException, stackTrace: stackTrace);
      return NetworkFailure<T>(appException);
    }
  }

  AppException _mapDioException(
    DioException error,
    StackTrace stackTrace,
    String? description,
  ) {
    final baseMessage = description != null ? '$description: ' : '';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutException(
          debugMessage: '${baseMessage}Request timed out: ${error.message}',
          stackTrace: stackTrace,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null && statusCode >= 500 && statusCode < 600) {
          return ServerException(
            statusCode: statusCode,
            debugMessage:
                '${baseMessage}Server error ($statusCode): ${error.message}',
            stackTrace: stackTrace,
          );
        }
        return UnexpectedException(
          debugMessage:
              '${baseMessage}Unexpected response (${statusCode ?? 'unknown'}): ${error.message}',
          stackTrace: stackTrace,
          cause: error,
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return NetworkException(
          debugMessage:
              '${baseMessage}Network connectivity issue: ${error.message}',
          stackTrace: stackTrace,
        );

      case DioExceptionType.cancel:
        return UnexpectedException(
          debugMessage:
              '${baseMessage}Request cancelled: ${error.message}',
          stackTrace: stackTrace,
        );
    }
  }
}

extension DioWithAppStability on Dio {
  Future<NetworkResult<T>> safeRequest<T>(
    Future<Response<T>> Function(Dio dio) request, {
    String? description,
    RetryPolicy? retryPolicy,
    ErrorReporter? errorReporter,
  }) async {
    final wrapper = AppDio(
      options: options,
      retryPolicy: retryPolicy,
      errorReporter: errorReporter,
    );

    if (kDebugMode && wrapper.dio != this) {
      AppLogger.warning('A new Dio instance was created for safeRequest.');
    }

    return wrapper.execute<T>(request, description: description);
  }
}
