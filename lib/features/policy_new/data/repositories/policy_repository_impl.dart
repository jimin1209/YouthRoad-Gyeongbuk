import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../../domain/values/policy_failure.dart';
import '../../domain/values/policy_filter.dart';
import '../../domain/values/policy_logger.dart';
import '../../domain/values/policy_region.dart';
import '../../domain/values/policy_query.dart';
import '../../domain/values/policy_result.dart';
import '../../domain/values/policy_settings.dart';
import '../../domain/values/policy_feed_type.dart';
import '../cache/policy_cache.dart';
import '../sources/policy_remote_source.dart';

class PolicyRepositoryImpl implements PolicyRepository {
  final PolicyRemoteSource remote;
  final PolicyCache cache;
  final PolicyLogger logger;
  final PolicySettings settings;

  PolicyRepositoryImpl({
    required this.remote,
    required this.cache,
    required this.logger,
    required this.settings,
  });

  Map<String, dynamic> _buildQueryParameters({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) {
    final params = <String, dynamic>{
      'page': page,
      'size': pageSize,
      'sort': query.sort.name,
    };

    if (query.keyword != null && query.keyword!.isNotEmpty) {
      params['keyword'] = query.keyword;
    }

    // Filter → API 파라미터 매핑
    final filter = query.filter;

    if (filter.region != PolicyRegion.all) {
      params['region'] = filter.region.name;
    }

    if (filter.category != null) {
      params['category'] = filter.category!.name;
    }

    if (filter.age != null) {
      params['age'] = filter.age;
    }

    if (filter.isOnline != null) {
      params['is_online'] = filter.isOnline! ? 'Y' : 'N';
    }

    if (filter.isOffline != null) {
      params['is_offline'] = filter.isOffline! ? 'Y' : 'N';
    }

    if (filter.isOngoing != null) {
      params['is_ongoing'] = filter.isOngoing! ? 'Y' : 'N';
    }

    final effectiveTags = query.tags.isNotEmpty ? query.tags : filter.tags;
    if (effectiveTags.isNotEmpty) {
      params['tags'] = effectiveTags.join(',');
    }

    // feedType에 따라 backend에서 다른 endpoint를 사용한다면 힌트 전달
    params['feed_type'] = query.feedType.name;

    return params;
  }

  @override
  Future<PolicyResult<List<Policy>>> fetchPolicies({
    required int page,
    required int pageSize,
  }) async {
    // 기본 Query: 전체 탭, 기본 지역/정렬
    final defaultFilter = PolicyFilter(
      region: settings.defaultRegion,
    );

    final defaultQuery = PolicyQuery(
      filter: defaultFilter,
      feedType: PolicyFeedType.all,
    );

    return fetchPoliciesByQuery(
      query: defaultQuery,
      page: page,
      pageSize: pageSize == 0 ? settings.pageSize : pageSize,
    );
  }

  @override
  Future<PolicyResult<List<Policy>>> fetchPoliciesByQuery({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) async {
    final effectivePageSize = pageSize == 0 ? settings.pageSize : pageSize;
    final scopeKey = query.cacheScopeKey;

    try {
      logger.info(
        'fetchPoliciesByQuery(scope: $scopeKey, page: $page, size: $effectivePageSize)',
      );

      if (settings.enableCache) {
        final cached = cache.getPageForScope(scopeKey, page);
        if (cached != null && cached.isNotEmpty) {
          logger.info('캐시 히트 (scope: $scopeKey, page: $page)');
          return PolicyResult.success(cached);
        }
      }

      final params = _buildQueryParameters(
        query: query,
        page: page,
        pageSize: effectivePageSize,
      );

      final models = await remote.fetchPoliciesWithParams(params);
      final domainList = models.map((e) => e.toDomain()).toList();

      if (settings.enableCache) {
        cache.savePageForScope(scopeKey, page, domainList);
      }

      return PolicyResult.success(domainList);
    } catch (e, st) {
      logger.error('fetchPoliciesByQuery 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }

  @override
  Future<PolicyResult<Policy>> fetchPolicyDetail(String id) async {
    try {
      logger.info('fetchPolicyDetail(id: $id) 호출');
      final model = await remote.fetchPolicyDetail(id);
      return PolicyResult.success(model.toDomain());
    } catch (e, st) {
      logger.error('fetchPolicyDetail 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }
}
