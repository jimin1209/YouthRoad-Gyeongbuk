sealed class PolicyFailure {
  final String message;

  const PolicyFailure(this.message);
}

class NetworkFailure extends PolicyFailure {
  const NetworkFailure([String msg = '네트워크 오류']) : super(msg);
}

class ServerFailure extends PolicyFailure {
  const ServerFailure([String msg = '서버 오류']) : super(msg);
}

class UnknownFailure extends PolicyFailure {
  const UnknownFailure([String msg = '알 수 없는 오류']) : super(msg);
}
