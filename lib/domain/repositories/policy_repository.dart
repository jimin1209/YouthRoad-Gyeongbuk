import '../../data/models/policy_filter.dart';
import '../entities/policy.dart';

abstract class PolicyRepository {
  Future<List<Policy>> fetchPolicies({
    PolicyFilter filter = const PolicyFilter(),
  });
  Future<Policy> fetchPolicyById(String id);
  Future<List<Policy>> fetchSimilarPolicies(String id);
}
