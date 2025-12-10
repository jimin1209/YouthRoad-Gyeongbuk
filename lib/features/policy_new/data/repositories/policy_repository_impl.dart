import 'dart:math';

import 'package:flutter/foundation.dart';

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
import '../../domain/values/policy_status_filter.dart';
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
    final normalizedQuery = query.normalize();
    final normalizedFilter = normalizedQuery.filter;
    final normalizedPage = page < 1 ? 1 : page;
    final normalizedSize = pageSize <= 0 ? settings.pageSize : pageSize;

    final params = <String, dynamic>{
      'pageIndex': normalizedPage,
      'pageSize': normalizedSize,
      'recordCount': normalizedSize,
      'pagingYn': 'Y',
      'searchDsplyYn': 'all',
      'feed_type': normalizedQuery.feedType.name,
      'sort': normalizedQuery.sort.name,
    };

    if (normalizedQuery.keyword != null && normalizedQuery.keyword!.isNotEmpty) {
      params['searchPolicyNm'] = normalizedQuery.keyword;
    }

    // Filter → API 파라미터 매핑
    final filter = normalizedFilter;

    final regionValue = _regionParam(filter);
    if (regionValue != null && regionValue.isNotEmpty) {
      params['searchRgnSe'] = regionValue;
    }

    if (filter.category != null) {
      params['searchPolicyType'] = _mapCategory(filter.category!);
    }

    if (filter.status == PolicyStatusFilter.inProgressOnly) {
      params['aplyPsbltyYn'] = 'Y';
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

    if (normalizedQuery.tags.isNotEmpty) {
      params['tags'] = normalizedQuery.tags.join(',');
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
      final cacheResult = _tryReturnCache(
        cache.getPageWithStatus(page, settings.cacheTtl),
        () => _fetchAndCacheDefault(page, effectivePageSize),
      );

      if (cacheResult != null) return cacheResult;
    }

    debugPrint('[CACHE:MISS]');
    return _fetchAndCacheDefault(page, effectivePageSize);
  }

  @override
  Future<PolicyResult<List<Policy>>> fetchPoliciesByQuery({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) async {
    final normalizedQuery = query.normalize();
    final effectivePageSize = pageSize == 0 ? settings.pageSize : pageSize;
    final scopeKey = normalizedQuery.cacheScopeKey;

    if (_isIdBasedQuery(normalizedQuery)) {
      if (settings.enableCache) {
        final cacheResult = _tryReturnCache(
          cache.getPageWithStatus(
            page,
            settings.cacheTtl,
            scope: scopeKey,
          ),
          () => _fetchAndCacheByIds(
            query: normalizedQuery,
            page: page,
            pageSize: effectivePageSize,
            scopeKey: scopeKey,
          ),
        );

        if (cacheResult != null) return cacheResult;
      }

      debugPrint('[CACHE:MISS]');
      return _fetchAndCacheByIds(
        query: normalizedQuery,
        page: page,
        pageSize: effectivePageSize,
        scopeKey: scopeKey,
      );
    }

    if (settings.enableCache) {
      final cacheResult = _tryReturnCache(
        cache.getPageWithStatus(
          page,
          settings.cacheTtl,
          scope: scopeKey,
        ),
        () => _fetchAndCacheQuery(
          query: normalizedQuery,
          page: page,
          pageSize: effectivePageSize,
          scopeKey: scopeKey,
        ),
      );

      if (cacheResult != null) return cacheResult;
    }

    debugPrint('[CACHE:MISS]');
    return _fetchAndCacheQuery(
      query: normalizedQuery,
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
    final normalizedQuery = query.normalize();
    final filter = normalizedQuery.filter;

    try {
      logger.info(
        '[Explore][INFO] fetchPoliciesByQuery(scope: $scopeKey, region: ${filter.region.name}/${filter.province}/${filter.city ?? '-'} (${filter.district ?? '-'}), status: ${filter.status.queryValue}, sort: ${normalizedQuery.sort.name}, keyword: ${normalizedQuery.keyword ?? '-'}, feed: ${normalizedQuery.feedType.name}, page: $page, size: $pageSize)',
      );

      final result = await _fetchFromRemote(
        query: normalizedQuery,
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
      logger.info(
        '원격 데이터 수신 요청 (scope: $scopeKey, page: $page, params: ${_debugParams(params)})',
      );

      final models = await remote.fetchPoliciesWithParams(params);
      final domainList = models.map((e) => e.toDomain()).toList();
      final filteredByStatus =
          _applyStatusFilter(query.filter, domainList);
      final filtered = _isIdBasedQuery(query)
          ? filteredByStatus
          : _applyTagFilter(query, filteredByStatus);
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

  bool _isIdBasedQuery(PolicyQuery query) =>
      query.feedType == PolicyFeedType.favorite ||
      query.feedType == PolicyFeedType.bookmarked ||
      query.feedType == PolicyFeedType.compare;

  List<Policy> _applyStatusFilter(PolicyFilter filter, List<Policy> list) {
    if (filter.status == PolicyStatusFilter.includeClosed) return list;

    final nowKst = DateTime.now().toUtc().add(const Duration(hours: 9));
    final today = DateTime(nowKst.year, nowKst.month, nowKst.day);

    bool isOngoing(Policy policy) {
      final start = policy.applicationStartDate;
      final end = policy.applicationEndDate;

      final startDate = start == null
          ? null
          : DateTime(start.year, start.month, start.day);
      final endDate = end == null
          ? null
          : DateTime(end.year, end.month, end.day);

      final hasStarted = startDate == null || !startDate.isAfter(today);
      final notEnded = endDate == null || !endDate.isBefore(today);
      return hasStarted && notEnded;
    }

    bool isClosed(Policy policy) {
      final end = policy.applicationEndDate;
      if (end == null) return false;
      final endDate = DateTime(end.year, end.month, end.day);
      return endDate.isBefore(today);
    }

    return list.where((policy) {
      if (filter.status == PolicyStatusFilter.inProgressOnly) {
        return isOngoing(policy);
      }
      return isClosed(policy);
    }).toList();
  }

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

    int compareDesc(DateTime? a, DateTime? b) {
      if (a == null && b == null) return 0;
      if (a == null) return 1;
      if (b == null) return -1;
      return b.compareTo(a);
    }

    DateTime? coalesce(DateTime? primary, DateTime? secondary) {
      return primary ?? secondary;
    }

    switch (sort) {
      case PolicySortOption.latest:
        sorted.sort((a, b) {
          return compareDesc(
            coalesce(a.createdAt, a.updatedAt),
            coalesce(b.createdAt, b.updatedAt),
          );
        });
        break;
      case PolicySortOption.recommendation:
        sorted.sort((a, b) {
          return compareDesc(
            coalesce(a.updatedAt, a.createdAt),
            coalesce(b.updatedAt, b.createdAt),
          );
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
        sorted.sort((a, b) {
          return compareDesc(
            coalesce(a.applicationStartDate, a.createdAt),
            coalesce(b.applicationStartDate, b.createdAt),
          );
        });
        break;
    }

    return sorted;
  }

  String _debugParams(Map<String, dynamic> params) {
    return params.entries.map((e) => '${e.key}=${e.value}').join(', ');
  }

  String? _mapRegion(PolicyRegion region) {
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
        return '경상북도';
      case PolicyRegion.all:
        return null;
    }
  }

  String? _regionParam(PolicyFilter filter) {
    final city = filter.city?.trim();
    if (city != null && city.isNotEmpty) {
      return city;
    }

    final province = filter.province.trim();
    if (filter.region == PolicyRegion.gyeongbuk && province.isNotEmpty) {
      return province;
    }

    final mappedRegion = _mapRegion(filter.region);
    if (mappedRegion != null && mappedRegion.isNotEmpty) {
      return mappedRegion;
    }

    return null;
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

  PolicyResult<List<Policy>>? _tryReturnCache(
    CacheLookupResult? cached,
    Future<PolicyResult<List<Policy>>> Function() refresher,
  ) {
    if (cached == null) return null;

    if (cached.isStale) {
      debugPrint('[CACHE:STALE]');
      _runAsyncRefresh(refresher);
    } else {
      debugPrint('[CACHE:HIT]');
    }

    return PolicyResult.success(cached.data);
  }

  void _runAsyncRefresh(
    Future<PolicyResult<List<Policy>>> Function() refresher, {
    String? context,
  }) {
    debugPrint('[ASYNC-REFRESH:STARTED]');
    Future(() async {
      try {
        final result = await refresher();
        if (!result.isSuccess) {
          logger.warn('SWR 재검증 실패${context != null ? ' ($context)' : ''}');
        }
      } catch (e, st) {
        logger.warn('SWR 재검증 중 예외 발생${context != null ? ' ($context)' : ''}');
        logger.error('SWR 재검증 실패', e, st);
      } finally {
        debugPrint('[ASYNC-REFRESH:COMPLETED]');
      }
    });
  }
}
