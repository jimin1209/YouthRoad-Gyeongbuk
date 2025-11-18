import 'dart:developer';
import 'dart:math';

import 'package:dio/dio.dart';

typedef TokenProvider = String? Function();

class ApiInterceptor extends Interceptor {
  ApiInterceptor({
    this.tokenProvider,
    Dio? dio,
    this.maxRetries = 3,
    this.backoffBase = const Duration(milliseconds: 500),
  }) : _dio = dio;

  final TokenProvider? tokenProvider;
  final Dio? _dio;
  final int maxRetries;
  final Duration backoffBase;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenProvider?.call();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    log('➡️ ${options.method} ${options.uri}', name: 'ApiInterceptor');
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final code = err.response?.statusCode;
    log('❌ ${code ?? 'ERR'} ${err.requestOptions.uri}: ${err.message}',
        name: 'ApiInterceptor');

    final retryCount = (err.requestOptions.extra['retry_count'] as int?) ?? 0;
    if (_shouldRetry(err, retryCount) && _dio != null) {
      final nextCount = retryCount + 1;
      final delay = _calculateBackoff(nextCount);
      log(
        '🔁 Retrying request ($nextCount/$maxRetries) after '
        '${delay.inMilliseconds}ms',
        name: 'ApiInterceptor',
      );
      await Future<void>.delayed(delay);
      final response = await _dio!.fetch<dynamic>(
        err.requestOptions.copyWith(
          extra: <String, dynamic>{
            ...err.requestOptions.extra,
            'retry_count': nextCount,
          },
        ),
      );
      handler.resolve(response);
      return;
    }

    handler.next(_mapStatusToError(err));
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('✅ ${response.statusCode} ${response.requestOptions.uri}',
        name: 'ApiInterceptor');
    super.onResponse(response, handler);
  }

  bool _shouldRetry(DioException err, int retryCount) {
    final statusCode = err.response?.statusCode;
    final isServerError = statusCode != null && statusCode >= 500;
    final isRateLimited = statusCode == 429;
    final isTimeoutError = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout;
    return retryCount < maxRetries &&
        (isRateLimited || isServerError || isTimeoutError);
  }

  Duration _calculateBackoff(int attempt) {
    return Duration(
      milliseconds: backoffBase.inMilliseconds * pow(2, attempt - 1).toInt(),
    );
  }

  DioException _mapStatusToError(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 429) {
      return error.copyWith(
        message: 'YouthRoad API rate limit exceeded (429). Please retry later.',
      );
    }
    if (statusCode != null && statusCode >= 500) {
      return error.copyWith(
        message: 'YouthRoad API is unavailable (HTTP $statusCode).',
      );
    }
    return error;
  }
}
