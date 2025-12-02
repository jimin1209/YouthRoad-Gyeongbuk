import 'policy_failure.dart';

class PolicyResult<T> {
  final T? data;
  final PolicyFailure? failure;

  const PolicyResult._({this.data, this.failure});

  bool get isSuccess => data != null && failure == null;

  factory PolicyResult.success(T data) => PolicyResult._(data: data);

  factory PolicyResult.failure(PolicyFailure failure) =>
      PolicyResult._(failure: failure);
}
