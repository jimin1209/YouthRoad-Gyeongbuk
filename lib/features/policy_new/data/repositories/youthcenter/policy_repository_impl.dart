import '../../cache/policy_local_cache.dart';
import '../../dto/policy_youthcenter_dto.dart';
import '../../mappers/youth_policy_mapper.dart';
import '../../sources/youthcenter/youth_policy_remote_source.dart';
import '../../../domain/youthcenter/paging_entity.dart';
import '../../../domain/youthcenter/policy_entity.dart';
import '../../../domain/youthcenter/policy_search_query.dart';
import '../../../domain/youthcenter/repositories/policy_repository.dart';

class PolicyRepositoryImpl implements PolicyRepository {
  PolicyRepositoryImpl({
    required YouthPolicyRemoteSource remoteSource,
    required PolicyLocalCache cache,
  })  : _remoteSource = remoteSource,
        _cache = cache;

  final YouthPolicyRemoteSource _remoteSource;
  final PolicyLocalCache _cache;

  @override
  Future<(List<PolicyEntity>, PagingEntity)> getPolicies(
    PolicySearchQuery query,
  ) async {
    final cachedPolicies = _cache.loadPolicies();
    final cachedPaging = _cache.loadPaging();

    if (cachedPolicies != null && cachedPaging != null && !_cache.isExpired(query.ttl)) {
      return (cachedPolicies, cachedPaging);
    }

    final dto = await _remoteSource.fetchPolicies(query);
    final result = dto.result;
    final items = result?.youthPolicyList ?? <PolicyYouthcenterItemDto>[];
    final policies = items.map((item) => item.toDomain()).toList();
    final paging = (result?.pagging).toDomain();

    await _cache.save(policies, paging);
    return (policies, paging);
  }
}
