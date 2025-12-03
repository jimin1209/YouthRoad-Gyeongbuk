import '../../domain/entities/policy.dart';

class CompareState {
  final List<Policy> policies;
  final Map<String, bool> diffs;

  const CompareState({
    required this.policies,
    required this.diffs,
  });

  const CompareState.empty()
      : policies = const [],
        diffs = const {};
}
