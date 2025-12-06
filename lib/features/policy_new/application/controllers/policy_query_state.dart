import '../../domain/values/policy_query.dart';

class PolicyQueryState {
  const PolicyQueryState({
    required this.query,
    required this.hash,
    required this.summary,
    required this.conditionSummary,
  });

  final PolicyQuery query;
  final String hash;
  final String summary;
  final String conditionSummary;
}
