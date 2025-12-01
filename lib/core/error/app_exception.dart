sealed class AppException implements Exception {
  const AppException({
    required this.userMessage,
    required this.debugMessage,
    this.stackTrace,
  });

  final String userMessage;
  final String debugMessage;
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType: $debugMessage';
}

class NetworkException extends AppException {
  const NetworkException({
    String userMessage = '네트워크 연결 상태를 확인해주세요.',
    required String debugMessage,
    StackTrace? stackTrace,
  }) : super(
          userMessage: userMessage,
          debugMessage: debugMessage,
          stackTrace: stackTrace,
        );
}

class ServerException extends AppException {
  const ServerException({
    String userMessage = '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
    required String debugMessage,
    this.statusCode,
    StackTrace? stackTrace,
  }) : super(
          userMessage: userMessage,
          debugMessage: debugMessage,
          stackTrace: stackTrace,
        );

  final int? statusCode;
}

class TimeoutException extends AppException {
  const TimeoutException({
    String userMessage = '요청 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.',
    required String debugMessage,
    StackTrace? stackTrace,
  }) : super(
          userMessage: userMessage,
          debugMessage: debugMessage,
          stackTrace: stackTrace,
        );
}

class UnexpectedException extends AppException {
  const UnexpectedException({
    String userMessage = '예기치 못한 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
    required String debugMessage,
    this.cause,
    StackTrace? stackTrace,
  }) : super(
          userMessage: userMessage,
          debugMessage: debugMessage,
          stackTrace: stackTrace,
        );

  final Object? cause;
}
