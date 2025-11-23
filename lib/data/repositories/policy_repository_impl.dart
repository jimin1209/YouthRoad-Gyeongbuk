import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../models/policy_filter.dart';
import '../sources/local/local_policy_source.dart';

class PolicyRepositoryImpl implements PolicyRepository {
  PolicyRepositoryImpl(this._localSource);

  final LocalPolicySource _localSource;

  @override
  Future<List<Policy>> fetchPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) async {
    final models = await _localSource.fetchDummyPolicies(filter: filter);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Policy> fetchPolicyById(String id) async {
    final model = await _localSource.fetchDummyPolicy(id);
    return model.toEntity();
  }

  @override
  Future<List<Policy>> fetchSimilarPolicies(String id) async {
    final models = await _localSource.fetchSimilar(id);
    if (models.isEmpty) {
      return fetchPolicies(filter: const PolicyFilter());
    }
    return models.map((m) => m.toEntity()).toList();
  }
}
