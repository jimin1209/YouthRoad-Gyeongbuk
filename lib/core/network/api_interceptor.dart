import 'package:dio/dio.dart';
import '../logging/app_logger.dart';
import '../logging/network_event.dart';

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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final code = err.response?.statusCode;
    AppLogger.recordNetworkEvent(NetworkLogEvent.fromError(err));
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.recordNetworkEvent(NetworkLogEvent.fromResponse(response));
    super.onResponse(response, handler);
  }
}
