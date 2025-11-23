import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../sources/local/local_policy_source.dart';

class PolicyRepositoryImpl implements PolicyRepository {
  PolicyRepositoryImpl(this._localSource);

  final LocalPolicySource _localSource;

  @override
  Future<List<Policy>> fetchPolicies({int page = 1}) async {
    final models = await _localSource.fetchDummyPolicies(page: page);
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
      return fetchPolicies();
    }
    return models.map((m) => m.toEntity()).toList();
  }
}
