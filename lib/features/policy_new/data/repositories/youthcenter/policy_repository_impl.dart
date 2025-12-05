import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
    {CancelToken? cancelToken}
  ) async {
    final cachedPolicies = _cache.loadPolicies();
    final cachedPaging = _cache.loadPaging();
    final hasCache = cachedPolicies != null && cachedPaging != null;

    if (hasCache && !_cache.isExpired(query.ttl)) {
      debugPrint('[CACHE-HIT:FRESH]');
      _logDomainCheck(cachedPolicies!, cachedPaging!);
      return (cachedPolicies!, cachedPaging!);
    }

    if (hasCache) {
      debugPrint('[CACHE-STALE:REFRESH]');
      _refreshCache(query, cancelToken);
      _logDomainCheck(cachedPolicies!, cachedPaging!);
      return (cachedPolicies!, cachedPaging!);
    }

    debugPrint('[CACHE-MISS:FETCH]');
    return _fetchAndCache(query, cancelToken);
  }

  Future<(List<PolicyEntity>, PagingEntity)> _fetchAndCache(
    PolicySearchQuery query,
    CancelToken? cancelToken,
  ) async {
    final dto = await _remoteSource.fetchPolicies(
      query,
      cancelToken: cancelToken,
    );
    final result = dto.result;
    final items = result?.youthPolicyList ?? <PolicyYouthcenterItemDto>[];
    final policies = items.map((item) => item.toDomain()).toList();
    final paging = (result?.pagging).toDomain();

    await _cache.save(policies, paging);
    _logDomainCheck(policies, paging);
    return (policies, paging);
  }

  void _refreshCache(PolicySearchQuery query, CancelToken? cancelToken) {
    Future(() async {
      try {
        await _fetchAndCache(query, cancelToken);
      } catch (error, stackTrace) {
        debugPrint('[CACHE] refresh failed: $error\n$stackTrace');
      }
    });
  }

  void _logDomainCheck(List<PolicyEntity> policies, PagingEntity paging) {
    debugPrint(
      '[DomainCheck] count=${policies.length}, page=${paging.pageNumber}, pageSize=${paging.pageSize}, total=${paging.totalCount}',
    );

    for (final policy in policies.take(3)) {
      debugPrint(
        '[DomainCheck] title="${policy.title}" region="${policy.region}" period="${policy.period}"',
      );
      if (policy.ageCondition != null) {
        debugPrint('[DomainCheck] ageRange=${policy.ageCondition}');
      }
    }
  }
}
