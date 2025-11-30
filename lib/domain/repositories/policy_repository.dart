import '../../data/models/policy_filter.dart';
import '../entities/policy.dart';

class PolicyFetchResult {
  const PolicyFetchResult({
    required this.policies,
    this.remoteRefresh,
  });

  final List<Policy> policies;
  final Future<List<Policy>>? remoteRefresh;
}

abstract class PolicyRepository {
  Future<PolicyFetchResult> getPolicies({
    PolicyFilter filter = const PolicyFilter(),
    bool forceRefresh = false,
  });

  Future<List<Policy>> refreshPolicies({
    PolicyFilter filter = const PolicyFilter(),
  });

  Future<List<Policy>> loadCachedPolicies({
    PolicyFilter filter = const PolicyFilter(),
  });

  Future<Policy> fetchPolicyById(String id);

  Future<List<Policy>> fetchSimilarPolicies(String id);
}
