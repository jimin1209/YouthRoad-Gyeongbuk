import 'dart:math';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../../domain/values/policy_failure.dart';
import '../../domain/values/policy_filter.dart';
import '../../domain/values/policy_logger.dart';
import '../../domain/values/policy_region.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_query.dart';
import '../../domain/values/policy_sort.dart';
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
      'pageIndex': page,
      'pageSize': pageSize,
      'recordCount': pageSize,
      'pagingYn': 'Y',
      'searchDsplyYn': 'all',
      'feed_type': query.feedType.name,
      'sort': query.sort.name,
    };

    if (query.keyword != null && query.keyword!.isNotEmpty) {
      params['searchPolicyNm'] = query.keyword;
    }

    // Filter → API 파라미터 매핑
    final filter = query.filter;

    if (filter.region != PolicyRegion.all) {
      params['searchRgnSe'] = _mapRegion(filter.region);
    }

    if (filter.category != null) {
      params['searchPolicyType'] = _mapCategory(filter.category!);
    }

    if (filter.isOngoing != null) {
      params['aplyPsbltyYn'] = filter.isOngoing! ? 'Y' : 'N';
    }

    if (filter.isOnline != null) {
      params['aplyYn'] = filter.isOnline! ? 'Y' : 'N';
    }

    if (filter.institutionId != null && filter.institutionId!.isNotEmpty) {
      params['instNo'] = filter.institutionId;
    }

    if (filter.departmentId != null && filter.departmentId!.isNotEmpty) {
      params['deptNo'] = filter.departmentId;
    }

    if (query.tags.isNotEmpty) {
      params['tags'] = query.tags.join(',');
    }

    if (filter.tags.isNotEmpty) {
      params['filterTags'] = filter.tags.join(',');
    }

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

    if (_isIdBasedQuery(query)) {
      return _fetchAndCacheByIds(
        query: query,
        page: page,
        pageSize: effectivePageSize,
        scopeKey: scopeKey,
      );
    }

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

  Future<PolicyResult<List<Policy>>> _fetchAndCacheByIds({
    required PolicyQuery query,
    required int page,
    required int pageSize,
    required String scopeKey,
  }) async {
    final ids = query.tags;

    if (ids.isEmpty) {
      return PolicyResult.success(<Policy>[]);
    }

    if (settings.enableCache) {
      final cached = cache.getPageForScope(scopeKey, page);
      if (cached != null) {
        _revalidateIds(query, page, pageSize, scopeKey);
        return PolicyResult.success(cached);
      }
    }

    return _loadPoliciesByIds(
      ids: ids,
      page: page,
      pageSize: pageSize,
      scopeKey: scopeKey,
    );
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
      final filtered = _isIdBasedQuery(query)
          ? domainList
          : _applyTagFilter(query, domainList);
      final sorted = _applySorting(query.sort, filtered);

      logger.info('원격 데이터 수신 (scope: $scopeKey, page: $page)');

      return PolicyResult.success(sorted);
    } catch (e, st) {
      logger.error('원격 데이터 수신 실패 (scope: $scopeKey, page: $page)', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }

  Future<PolicyResult<List<Policy>>> _loadPoliciesByIds({
    required List<String> ids,
    required int page,
    required int pageSize,
    required String scopeKey,
  }) async {
    try {
      final start = (page - 1) * pageSize;
      if (start >= ids.length) {
        return PolicyResult.success(<Policy>[]);
      }

      final end = min(start + pageSize, ids.length);
      final slice = ids.sublist(start, end);

      final policies = <Policy>[];
      for (final id in slice) {
        final detail = await fetchPolicyDetail(id);
        if (!detail.isSuccess || detail.data == null) {
          return PolicyResult.failure(
            detail.failure ?? const UnknownFailure(),
          );
        }
        policies.add(detail.data!);
      }

      if (settings.enableCache) {
        cache.savePageForScope(scopeKey, page, policies);
      }

      return PolicyResult.success(policies);
    } catch (e, st) {
      logger.error('ID 기반 정책 조회 실패 (scope: $scopeKey, page: $page)', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }

  void _revalidateIds(
    PolicyQuery query,
    int page,
    int pageSize,
    String scopeKey,
  ) {
    Future(() async {
      final result = await _loadPoliciesByIds(
        ids: query.tags,
        page: page,
        pageSize: pageSize,
        scopeKey: scopeKey,
      );

      if (!result.isSuccess) {
        logger.warn('ID 기반 SWR 실패 (scope: $scopeKey, page: $page)');
      }
    });
  }

  bool _isIdBasedQuery(PolicyQuery query) =>
      query.feedType == PolicyFeedType.favorite ||
      query.feedType == PolicyFeedType.compare;

  List<Policy> _applyTagFilter(PolicyQuery query, List<Policy> list) {
    final combinedTags = {
      ...query.tags,
      ...query.filter.tags,
    }..removeWhere((tag) => tag.trim().isEmpty);

    if (combinedTags.isEmpty) return list;

    return list.where((policy) {
      final haystack =
          '${policy.title} ${policy.summary} ${policy.institution} ${policy.department}'
              .toLowerCase();
      return combinedTags.any(
        (tag) => haystack.contains(tag.toLowerCase()),
      );
    }).toList();
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

  List<Policy> _applySorting(PolicySortOption sort, List<Policy> list) {
    final sorted = List<Policy>.from(list);

    int compareDate(DateTime? a, DateTime? b) {
      if (a == null && b == null) return 0;
      if (a == null) return 1;
      if (b == null) return -1;
      return b.compareTo(a);
    }

    switch (sort) {
      case PolicySortOption.latest:
      case PolicySortOption.recommendation:
        sorted.sort((a, b) {
          final updatedCompare = compareDate(a.updatedAt, b.updatedAt);
          if (updatedCompare != 0) return updatedCompare;
          return compareDate(a.createdAt, b.createdAt);
        });
        break;
      case PolicySortOption.deadline:
        sorted.sort((a, b) {
          final endA = a.applicationEndDate;
          final endB = b.applicationEndDate;
          if (endA == null && endB == null) return 0;
          if (endA == null) return 1;
          if (endB == null) return -1;
          return endA.compareTo(endB);
        });
        break;
      case PolicySortOption.popularity:
        sorted.sort((a, b) => compareDate(a.createdAt, b.createdAt));
        break;
    }

    return sorted;
  }

  String _mapRegion(PolicyRegion region) {
    switch (region) {
      case PolicyRegion.seoul:
        return '서울';
      case PolicyRegion.busan:
        return '부산';
      case PolicyRegion.daegu:
        return '대구';
      case PolicyRegion.incheon:
        return '인천';
      case PolicyRegion.gwangju:
        return '광주';
      case PolicyRegion.daejeon:
        return '대전';
      case PolicyRegion.ulsan:
        return '울산';
      case PolicyRegion.gyeongbuk:
        return '경북 전체';
      case PolicyRegion.all:
        return '전체';
    }
  }

  String _mapCategory(PolicyCategory category) {
    switch (category) {
      case PolicyCategory.employment:
        return '취업';
      case PolicyCategory.startup:
        return '창업';
      case PolicyCategory.housing:
        return '주거';
      case PolicyCategory.life:
        return '생활';
      case PolicyCategory.education:
        return '교육';
      case PolicyCategory.welfare:
        return '복지';
      case PolicyCategory.culture:
        return '문화';
      case PolicyCategory.other:
        return '기타';
    }
  }
}
