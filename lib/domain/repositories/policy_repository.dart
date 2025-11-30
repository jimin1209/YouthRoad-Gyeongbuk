import '../../data/models/policy_filter.dart';
import '../../data/policy/policy_repository.dart' show PolicyFetchResult;
import '../entities/policy.dart';

abstract class PolicyRepository {
  Future<List<Policy>> fetchPolicies({
    PolicyFilter filter = const PolicyFilter(),
  });

  Future<Policy> fetchPolicyById(String id);

  Future<List<Policy>> fetchSimilarPolicies(String id);

  Future<PolicyFetchResult> getPolicies({
    PolicyFilter filter = const PolicyFilter(),
    bool forceRefresh = false,
  });

  Future<List<Policy>> refreshPolicies({
    PolicyFilter filter = const PolicyFilter(),
    bool replaceExisting = false,
  });

  Future<List<Policy>> loadCachedPolicies({
    PolicyFilter filter = const PolicyFilter(),
  });
}
