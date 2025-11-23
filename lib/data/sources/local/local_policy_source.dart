import '../../models/policy_filter.dart';
import '../../models/policy_model.dart';

class LocalPolicySource {
  static const _mockPolicies = <PolicyModel>[];

  Future<List<PolicyModel>> fetchDummyPolicies({PolicyFilter? filter}) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _mockPolicies;
  }

  Future<PolicyModel> fetchDummyPolicy(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    throw StateError('Mock data is disabled');
  }

  Future<List<PolicyModel>> fetchSimilar(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return const [];
  }
}
