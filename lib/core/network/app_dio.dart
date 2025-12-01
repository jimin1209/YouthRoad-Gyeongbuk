import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../debug/debug_network_logger.dart';
import '../../devtools/devtools_provider.dart';

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
