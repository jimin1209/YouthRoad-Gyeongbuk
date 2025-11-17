import '../entities/policy.dart';

abstract class PolicyRepository {
  Future<List<Policy>> fetchPolicies();
}
