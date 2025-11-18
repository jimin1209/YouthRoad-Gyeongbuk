import 'package:dio/dio.dart';
import 'api_interceptor.dart';

Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.youthroad.kr/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  dio.interceptors.add(ApiInterceptor(dio: dio));
  return dio;
}
