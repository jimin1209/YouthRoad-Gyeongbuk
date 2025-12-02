import '../entities/policy.dart';
import '../values/policy_query.dart';
import '../values/policy_result.dart';

abstract class PolicyRepository {
  Future<PolicyResult<List<Policy>>> fetchPoliciesByQuery({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  });

  Future<PolicyResult<Policy>> fetchPolicyDetail(String id);
}
