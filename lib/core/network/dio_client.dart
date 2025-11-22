import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 공용 Dio 클라이언트 (신규 UX용). 기존 클라이언트와 병행 사용.
final dioClientProvider = Provider<Dio>((ref) {
  final BaseOptions options = BaseOptions(
    baseUrl: 'https://gbyouth.co.kr',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    contentType: 'application/json',
  );
  final dio = Dio(options);
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Accept'] = 'application/json';
        return handler.next(options);
      },
    ),
  );
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: true,
        responseHeader: false,
        request: false,
      ),
    );
  }
  return dio;
});
