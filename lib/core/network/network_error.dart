import 'package:dio/dio.dart';

/// YouthRoad domain-level error categories so the UI can make user-friendly
/// decisions regardless of the underlying HTTP client error.
enum YouthRoadErrorCategory {
  network,
  server,
  filter,
}

class YouthRoadException implements Exception {
  YouthRoadException(this.category, {this.statusCode, this.message, this.cause});

  final YouthRoadErrorCategory category;
  final int? statusCode;
  final String? message;
  final Object? cause;

  @override
  String toString() {
    final buffer = StringBuffer('YouthRoadException($category');
    if (statusCode != null) buffer.write(', status: $statusCode');
    if (message != null) buffer.write(', message: $message');
    buffer.write(')');
    return buffer.toString();
  }
}

class YouthRoadErrorMapper {
  YouthRoadErrorMapper._();

  static YouthRoadException fromDio(DioException error) {
    if (_isNetworkTimeout(error)) {
      return YouthRoadException(
        YouthRoadErrorCategory.network,
        message: error.message,
        statusCode: error.response?.statusCode,
        cause: error,
      );
    }

    final status = error.response?.statusCode;
    if (status != null) {
      if (status >= 500) {
        return YouthRoadException(
          YouthRoadErrorCategory.server,
          statusCode: status,
          message: error.message,
          cause: error,
        );
      }
      if (status >= 400) {
        return YouthRoadException(
          YouthRoadErrorCategory.filter,
          statusCode: status,
          message: error.message,
          cause: error,
        );
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return YouthRoadException(
          YouthRoadErrorCategory.network,
          statusCode: status,
          message: error.message,
          cause: error,
        );
      case DioExceptionType.badResponse:
        return YouthRoadException(
          status != null && status >= 500
              ? YouthRoadErrorCategory.server
              : YouthRoadErrorCategory.filter,
          statusCode: status,
          message: error.message,
          cause: error,
        );
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return YouthRoadException(
          YouthRoadErrorCategory.network,
          statusCode: status,
          message: error.message,
          cause: error,
        );
    }
  }

  static bool _isNetworkTimeout(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
  }
}
