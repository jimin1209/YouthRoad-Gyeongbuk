import '../entities/policy.dart';

abstract class PolicyRepository {
  Future<List<Policy>> fetchPolicies({int page = 1});
  Future<Policy> fetchPolicyById(String id);
  Future<List<Policy>> fetchSimilarPolicies(String id);
}
