import 'dart:developer';
import 'dart:math';

import 'package:dio/dio.dart';
import '../logging/app_logger.dart';
import '../logging/network_event.dart';

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
    options.extra['startedAt'] = DateTime.now();
    AppLogger.recordNetworkEvent(
      NetworkLogEvent(
        method: options.method,
        uri: options.uri,
        requestBody: options.data,
        extra: {'query': options.queryParameters},
      ),
    );
    super.onRequest(options, handler);
  }

@override
Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
  // 네트워크 이벤트 로깅 (AppLogger)
  AppLogger.recordNetworkEvent(NetworkLogEvent.fromError(err));

  final code = err.response?.statusCode;

  // 콘솔 로그
  log(
    '❌ ${code ?? 'ERR'} ${err.requestOptions.uri}: ${err.message}',
    name: 'ApiInterceptor',
  );

  // 재시도 카운트
  final retryCount = (err.requestOptions.extra['retry_count'] as int?) ?? 0;

  // 재시도 조건 & 백오프
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

  // 재시도 불가 → 상태코드 매핑 후 넘기기
  handler.next(_mapStatusToError(err));
}

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.recordNetworkEvent(NetworkLogEvent.fromResponse(response));
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
