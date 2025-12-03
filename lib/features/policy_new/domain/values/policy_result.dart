import 'policy_failure.dart';

class PolicyResult<T> {
  final T? data;
  final PolicyFailure? failure;

  const PolicyResult._({this.data, this.failure});

  bool get isSuccess => data != null && failure == null;

  factory PolicyResult.success(T data) => PolicyResult._(data: data);

  factory PolicyResult.failure(PolicyFailure failure) =>
      PolicyResult._(failure: failure);

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(PolicyFailure failure) onFailure,
  }) {
    if (data != null) {
      return onSuccess(data as T);
    }
    return onFailure(failure as PolicyFailure);
  }
}
