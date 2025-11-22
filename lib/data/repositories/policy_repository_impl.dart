import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../sources/local/local_policy_source.dart';

class PolicyRepositoryImpl implements PolicyRepository {
  PolicyRepositoryImpl(this._localSource);

  final LocalPolicySource _localSource;

  @override
  Future<List<Policy>> fetchPolicies() async {
    final models = await _localSource.fetchDummyPolicies();
    return models.map((m) => m.toEntity()).toList();
  }
}
