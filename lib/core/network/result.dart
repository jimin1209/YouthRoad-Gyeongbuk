/// 코드 생성 명령:
/// flutter pub run build_runner build --delete-conflicting-outputs

/// A simple Result type to wrap success or failure responses.
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(AppError error) failure,
  }) {
    final self = this;
    if (self is Success<T>) {
      return success(self.data);
    }
    if (self is Failure<T>) {
      return failure(self.error);
    }
    throw StateError('Unhandled Result state: $self');
  }
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppError error;
}

/// Simple error model used across layers.
class AppError {
  const AppError({
    required this.message,
    this.code,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final StackTrace? stackTrace;
}
