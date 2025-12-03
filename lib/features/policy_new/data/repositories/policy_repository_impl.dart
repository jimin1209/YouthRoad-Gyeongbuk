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

    if (filter.tags.isNotEmpty) {
      params['tag_filters'] = filter.tags.join(',');
    }

    if (query.tags.isNotEmpty) {
      params['tags'] = query.tags.join(',');
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
    final effectivePageSize = pageSize == 0 ? settings.pageSize : pageSize;

    if (settings.enableCache) {
      final cached = cache.getPage(page);
      if (cached != null && cached.isNotEmpty) {
        _revalidateDefault(page, effectivePageSize);
        return PolicyResult.success(cached);
      }
    }

    return _fetchAndCacheDefault(page, effectivePageSize);
  }

  @override
  Future<PolicyResult<List<Policy>>> fetchPoliciesByQuery({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) async {
    final effectivePageSize = pageSize == 0 ? settings.pageSize : pageSize;
    final scopeKey = query.cacheScopeKey;

    if (settings.enableCache) {
      final cached = cache.getPageForScope(scopeKey, page);
      if (cached != null && cached.isNotEmpty) {
        logger.info('캐시 히트 (scope: $scopeKey, page: $page)');
        _revalidateQuery(query, page, effectivePageSize);
        return PolicyResult.success(cached);
      }
    }

    return _fetchAndCacheQuery(
      query: query,
      page: page,
      pageSize: effectivePageSize,
      scopeKey: scopeKey,
    );
  }

  Future<PolicyResult<List<Policy>>> _fetchAndCacheDefault(
    int page,
    int effectivePageSize,
  ) async {
    // 기본 Query: 전체 탭, 기본 지역/정렬
    final defaultFilter = PolicyFilter(
      region: PolicyRegion.all,
    );

    final defaultQuery = PolicyQuery(
      filter: defaultFilter,
      feedType: PolicyFeedType.all,
    );

    final result = await _fetchFromRemote(
      query: defaultQuery,
      page: page,
      pageSize: effectivePageSize,
    );

    if (settings.enableCache && result.isSuccess && result.data != null) {
      cache.savePage(page, result.data!);
      cache.savePageForScope(defaultQuery.cacheScopeKey, page, result.data!);
    }

    return result;
  }

  Future<PolicyResult<List<Policy>>> _fetchAndCacheQuery({
    required PolicyQuery query,
    required int page,
    required int pageSize,
    required String scopeKey,
  }) async {
    try {
      logger.info(
        'fetchPoliciesByQuery(scope: $scopeKey, page: $page, size: $pageSize)',
      );

      final result = await _fetchFromRemote(
        query: query,
        page: page,
        pageSize: pageSize,
      );

      if (settings.enableCache && result.isSuccess && result.data != null) {
        cache.savePageForScope(scopeKey, page, result.data!);
      }

      return result;
    } catch (e, st) {
      logger.error('fetchPoliciesByQuery 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }

  Future<PolicyResult<List<Policy>>> _fetchFromRemote({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) async {
    final scopeKey = query.cacheScopeKey;

    final params = _buildQueryParameters(
      query: query,
      page: page,
      pageSize: pageSize,
    );

    try {
      final models = await remote.fetchPoliciesWithParams(params);
      final domainList = models.map((e) => e.toDomain()).toList();

      logger.info('원격 데이터 수신 (scope: $scopeKey, page: $page)');

      return PolicyResult.success(domainList);
    } catch (e, st) {
      logger.error('원격 데이터 수신 실패 (scope: $scopeKey, page: $page)', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }

  void _revalidateQuery(PolicyQuery query, int page, int pageSize) {
    Future(() async {
      final scopeKey = query.cacheScopeKey;
      final result = await _fetchAndCacheQuery(
        query: query,
        page: page,
        pageSize: pageSize,
        scopeKey: scopeKey,
      );

      if (!result.isSuccess) {
        logger.warn('SWR 재검증 실패 (scope: $scopeKey, page: $page)');
      }
    });
  }

  void _revalidateDefault(int page, int pageSize) {
    Future(() async {
      final result = await _fetchAndCacheDefault(page, pageSize);
      if (!result.isSuccess) {
        logger.warn('SWR 재검증 실패 (page: $page)');
      }
    });
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
