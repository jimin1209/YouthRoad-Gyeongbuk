import 'package:dio/dio.dart';

import 'result.dart';

Future<Result<T>> safeApiCall<T>(Future<T> Function() call) async {
  try {
    final T data = await call();
    return Success<T>(data);
  } on DioException catch (e, st) {
    return Failure<T>(mapDioError(e, st));
  } catch (e, st) {
    return Failure<T>(
      AppError(
        message: e.toString(),
        stackTrace: st,
      ),
    );
  }
}

AppError mapDioError(DioException error, StackTrace stackTrace) {
  final Response<dynamic>? response = error.response;
  final int? status = response?.statusCode;

  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return AppError(
      message: '네트워크 응답 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.',
      code: 'timeout',
      stackTrace: stackTrace,
    );
  }

  if (error.type == DioExceptionType.badResponse) {
    return AppError(
      message: '서버 오류가 발생했습니다. code: $status',
      code: status?.toString(),
      stackTrace: stackTrace,
    );
  }

  return AppError(
    message: error.message ?? '네트워크 오류가 발생했습니다.',
    code: 'network_error',
    stackTrace: stackTrace,
  );
}
