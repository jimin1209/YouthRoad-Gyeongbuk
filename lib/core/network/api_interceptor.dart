import 'dart:developer';

import 'package:dio/dio.dart';

typedef TokenProvider = String? Function();

class ApiInterceptor extends Interceptor {
  ApiInterceptor({this.tokenProvider});

  final TokenProvider? tokenProvider;

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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final code = err.response?.statusCode;
    log('❌ ${code ?? 'ERR'} ${err.requestOptions.uri}: ${err.message}',
        name: 'ApiInterceptor');
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('✅ ${response.statusCode} ${response.requestOptions.uri}',
        name: 'ApiInterceptor');
    super.onResponse(response, handler);
  }
}
