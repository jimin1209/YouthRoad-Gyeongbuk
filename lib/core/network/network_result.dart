import '../error/app_exception.dart';

sealed class NetworkResult<T> {
  const NetworkResult();

  bool get isSuccess => this is NetworkSuccess<T>;
  bool get isFailure => this is NetworkFailure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) {
    final self = this;
    if (self is NetworkSuccess<T>) {
      return success(self.data);
    }
    return failure((self as NetworkFailure<T>).error);
  }
}

class NetworkSuccess<T> extends NetworkResult<T> {
  const NetworkSuccess(this.data);

  final T data;
}

class NetworkFailure<T> extends NetworkResult<T> {
  const NetworkFailure(this.error);

  final AppException error;
}

extension NetworkResultFactory<T> on NetworkResult<T> {
  static NetworkResult<T> success<T>(T data) => NetworkSuccess<T>(data);

  static NetworkResult<T> failure<T>(AppException error) => NetworkFailure<T>(error);
}
