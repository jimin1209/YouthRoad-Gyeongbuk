import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_config.dart';

final dioProvider = Provider<Dio>((ref) {
  final YouthApiConfig config = ref.watch(youthApiConfigProvider);
  final BaseOptions options = BaseOptions(
    baseUrl: config.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    contentType: 'application/json',
    responseType: ResponseType.json,
  );

  final Dio dio = Dio(options);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Accept'] = 'application/json';
        return handler.next(options);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      request: false,
      responseBody: kDebugMode,
      responseHeader: false,
      requestBody: false,
      error: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ));
  }

  return dio;
});
