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

  // ===========================================================
  // QUERY PARAM BUILDING
  // ===========================================================
  Map<String, dynamic> _buildQueryParameters({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) {
    final sanitizedQuery = _sanitizeQueryForExplore(query);
    final normalizedQuery = sanitizedQuery.normalize();
    final normalizedFilter = normalizedQuery.filter;

    final normalizedPage = page < 1 ? 1 : page;
    final normalizedSize = pageSize <= 0 ? settings.pageSize : pageSize;

    final params = <String, dynamic>{
      'pageIndex': normalizedPage,
      'pageSize': normalizedSize,
      'recordCount': normalizedSize,
      'pagingYn': 'Y',

      // Explore = 반드시 Y (서버가 all/빈값 허용 안 함)
      'searchDsplyYn': _isExploreFeed(normalizedQuery.feedType) ? 'Y' : 'all',

      'feed_type': normalizedQuery.feedType.name,
      'sort': normalizedQuery.sort.name,
    };

    // 검색어
    if (normalizedQuery.keyword != null &&
        normalizedQuery.keyword!.isNotEmpty) {
      params['searchPolicyNm'] = normalizedQuery.keyword;
    }

    // REGION → searchRgnSe
    final isExploreFeed = _isExploreFeed(normalizedQuery.feedType);
    final regionValue = _regionParam(
      normalizedFilter,
      explore: isExploreFeed,
    );

    if (regionValue != null && regionValue.isNotEmpty) {
      params['searchRgnSe'] = regionValue;
    }

    // STATUS
    final statusValue = _mapStatusParam(normalizedFilter.status);
    if (statusValue != null) {
      params['status'] = statusValue;
    }

    // CATEGORY
    if (normalizedFilter.category != null) {
      params['searchPolicyType'] = _mapCategory(normalizedFilter.category!);
    }

    // 온라인 여부
    if (normalizedFilter.isOnline != null) {
      params['aplyYn'] = normalizedFilter.isOnline! ? 'Y' : 'N';
    }

    // 기관
    if (normalizedFilter.institutionId != null &&
        normalizedFilter.institutionId!.isNotEmpty) {
      params['instNo'] = normalizedFilter.institutionId;
    }

    // 부서
    if (normalizedFilter.departmentId != null &&
        normalizedFilter.departmentId!.isNotEmpty) {
      params['deptNo'] = normalizedFilter.departmentId;
    }

    // tags
    if (normalizedQuery.tags.isNotEmpty) {
      params['tags'] = normalizedQuery.tags.join(',');
    }

    if (normalizedFilter.tags.isNotEmpty) {
      params['filterTags'] = normalizedFilter.tags.join(',');
    }

    _sanitizeParams(params);
    return params;
  }

  // searchRgnSe 삭제 금지
  void _sanitizeParams(Map<String, dynamic> params) {
    params.removeWhere((key, value) {
      if (key == 'status') return value == null;
      if (key == 'searchRgnSe') return false;

      if (value == null) return true;
      if (value is String) {
        final trimmed = value.trim();
        if (trimmed.isEmpty) return true;
        if (key == 'searchPolicyType' && trimmed.toLowerCase() == 'all') {
          return true;
        }
      }
      return false;
    });
  }

  // ===========================================================
  // FETCHERS
  // ===========================================================
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
    final sanitizedQuery = _sanitizeQueryForExplore(query);
    final normalizedQuery = sanitizedQuery.normalize();

    final effectivePageSize = pageSize == 0 ? settings.pageSize : pageSize;
    final scopeKey = normalizedQuery.cacheScopeKey;

    if (_isIdBasedQuery(normalizedQuery)) {
      if (settings.enableCache) {
        final cacheResult = _tryReturnCache(
          cache.getPageWithStatus(page, settings.cacheTtl, scope: scopeKey),
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
        cache.getPageWithStatus(page, settings.cacheTtl, scope: scopeKey),
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

  // -----------------------------------------------------------
  // DEFAULT FETCH
  // -----------------------------------------------------------
  Future<PolicyResult<List<Policy>>> _fetchAndCacheDefault(
    int page,
    int effectivePageSize,
  ) async {
    final defaultFilter = PolicyFilter(region: PolicyRegion.all);
    final defaultQuery = PolicyQuery(
      filter: defaultFilter,
      feedType: PolicyFeedType.all,
    );

    final sanitizedDefaultQuery = _sanitizeQueryForExplore(defaultQuery);

    final result = await _fetchFromRemote(
      query: sanitizedDefaultQuery,
      page: page,
      pageSize: effectivePageSize,
    );

    if (settings.enableCache && result.isSuccess && result.data != null) {
      cache.savePage(page, result.data!);
      cache.savePageForScope(
        sanitizedDefaultQuery.cacheScopeKey,
        page,
        result.data!,
      );
    }

    return result;
  }

  // -----------------------------------------------------------
  // QUERY FETCH
  // -----------------------------------------------------------
  Future<PolicyResult<List<Policy>>> _fetchAndCacheQuery({
    required PolicyQuery query,
    required int page,
    required int pageSize,
    required String scopeKey,
  }) async {
    final sanitizedQuery = _sanitizeQueryForExplore(query);
    final normalizedQuery = sanitizedQuery.normalize();
    final filter = normalizedQuery.filter;

    try {
      logger.info(
        '[Explore][INFO] fetchPoliciesByQuery(scope: $scopeKey, '
        'region: ${filter.region.name}/${filter.province}/${filter.city ?? '-'} (${filter.district ?? '-'}), '
        'status: ${filter.status.queryValue}, sort: ${normalizedQuery.sort.name}, keyword: ${normalizedQuery.keyword ?? '-'}, '
        'feed: ${normalizedQuery.feedType.name}, page: $page, size: $pageSize)',
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

  // -----------------------------------------------------------
  // ID-BASED FETCH
  // -----------------------------------------------------------
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

  // -----------------------------------------------------------
  // REMOTE CALL
  // -----------------------------------------------------------
  Future<PolicyResult<List<Policy>>> _fetchFromRemote({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) async {
    final sanitizedQuery = _sanitizeQueryForExplore(query);
    final scopeKey = sanitizedQuery.cacheScopeKey;

    final params = _buildQueryParameters(
      query: sanitizedQuery,
      page: page,
      pageSize: pageSize,
    );

    debugPrint('[Explore][Sanitized Params] $params');

    if (_isExploreFeed(sanitizedQuery.feedType)) {
      debugPrint(
        '[Policy][Explore][FETCH] status=${sanitizedQuery.filter.status.queryValue}, '
        'category=${sanitizedQuery.filter.category?.name ?? 'null'}, '
        'keyword=${sanitizedQuery.keyword ?? '-'}, page=$page, size=$pageSize',
      );
    }

    try {
      logger.info(
        '원격 데이터 수신 요청 (scope: $scopeKey, page: $page, params: ${_debugParams(params)})',
      );

      final models = await remote.fetchPoliciesWithParams(params);
      final domainList = models.map((e) => e.toDomain()).toList();

      final filteredByStatus =
          _applyStatusFilter(sanitizedQuery.filter, domainList);
      final filtered = _isIdBasedQuery(sanitizedQuery)
          ? filteredByStatus
          : _applyTagFilter(sanitizedQuery, filteredByStatus);
      final sorted = _applySorting(sanitizedQuery.sort, filtered);

      logger.info(
        '원격 데이터 수신 (scope: $scopeKey, page: $page, fetched=${models.length}, filtered=${sorted.length})',
      );

      return PolicyResult.success(sorted);
    } catch (e, st) {
      logger.error('원격 데이터 수신 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }

  // ===========================================================
  // MISSING METHOD #1 — fetchPolicyDetail
  // ===========================================================
  @override
  Future<PolicyResult<Policy>> fetchPolicyDetail(String id) async {
    try {
      final model = await remote.fetchPolicyDetail(id);
      final domain = model.toDomain();
      return PolicyResult.success(domain);
    } catch (e, st) {
      logger.error('정책 상세 조회 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }

  // ===========================================================
  // MISSING METHOD #2 — _mapCategory
  // ===========================================================
  String _mapCategory(PolicyCategory category) {
    switch (category) {
      case PolicyCategory.employment:
        return 'employment';
      case PolicyCategory.startup:
        return 'startup';
      case PolicyCategory.housing:
        return 'housing';
      case PolicyCategory.life:
        return 'life';
      case PolicyCategory.education:
        return 'education';
      case PolicyCategory.welfare:
        return 'welfare';
      case PolicyCategory.culture:
        return 'culture';
      case PolicyCategory.other:
        return 'other';
    }
  }

  // ===========================================================
  // MISSING METHOD #3 — _loadPoliciesByIds
  // ===========================================================
  Future<PolicyResult<List<Policy>>> _loadPoliciesByIds({
    required List<String> ids,
    required int page,
    required int pageSize,
    required String scopeKey,
  }) async {
    try {
      final models = await remote.fetchPoliciesByIds(ids);
      final domainList = models.map((e) => e.toDomain()).toList();
      return PolicyResult.success(domainList);
    } catch (e, st) {
      logger.error('_loadPoliciesByIds 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }
  // ===========================================================
  // TAG FILTER / SORT HELPERS
  // ===========================================================

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

      final startDate =
          start == null ? null : DateTime(start.year, start.month, start.day);
      final endDate =
          end == null ? null : DateTime(end.year, end.month, end.day);

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

  // ===========================================================
  // SORTING HELPERS
  // ===========================================================
  List<Policy> _applySorting(PolicySortOption sort, List<Policy> list) {
    final sorted = List<Policy>.from(list);

    int compareDesc(DateTime? a, DateTime? b) {
      if (a == null && b == null) return 0;
      if (a == null) return 1;
      if (b == null) return -1;
      return b.compareTo(a);
    }

    DateTime? coalesce(DateTime? a, DateTime? b) => a ?? b;

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

  // ===========================================================
  // EXPLORE SANITIZING / REGION MAPPING (한국어 버전)
  // ===========================================================

  PolicyQuery _sanitizeQueryForExplore(PolicyQuery query) {
    if (!_isExploreFeed(query.feedType)) return query;

    final sanitizedFilter =
        _sanitizeFilterForExplore(query.filter, feedType: query.feedType);

    return query.copyWith(filter: sanitizedFilter);
  }

  String? _mapStatusParam(PolicyStatusFilter status) {
    switch (status) {
      case PolicyStatusFilter.includeClosed:
        return '';
      case PolicyStatusFilter.inProgressOnly:
        return 'inProgress';
      case PolicyStatusFilter.closedOnly:
        return 'closed';
    }
  }

  PolicyFilter _sanitizeFilterForExplore(
    PolicyFilter filter, {
    required PolicyFeedType feedType,
  }) {
    final sanitizedCategory = _sanitizeCategoryForExplore(filter.category);
    final mappedSearchRgnSe = _mapSearchRgnSeForExplore(filter, feedType);

    return filter.copyWith(
      status: filter.status,
      category: sanitizedCategory,
      searchRgnSe: mappedSearchRgnSe,
    );
  }

  /// 🔥 Explore 기본 지역은 무조건 한글 "경상북도"
  String _mapSearchRgnSeForExplore(
    PolicyFilter filter,
    PolicyFeedType feedType,
  ) {
    final explicit = _normalizeRegionSegment(filter.searchRgnSe);
    if (explicit != null && explicit.isNotEmpty) return explicit;

    final city = _normalizeRegionSegment(filter.city);
    final district = _normalizeRegionSegment(filter.district);

    if (district != null && district.isNotEmpty) return district;
    if (city != null && city.isNotEmpty) return city;

    // Explore 기본 지역 고정: "경상북도"
    return '경상북도';
  }

  PolicyCategory? _sanitizeCategoryForExplore(PolicyCategory? category) {
    final name = category?.name.toLowerCase();
    if (name == 'all') return null;
    return category;
  }

  bool _isExploreFeed(PolicyFeedType feedType) =>
      feedType == PolicyFeedType.all ||
      feedType == PolicyFeedType.region ||
      feedType == PolicyFeedType.search;

String? _regionParam(
  PolicyFilter filter, {
  bool explore = false,
}) {
  if (explore) {
    // searchRgnSe가 영어면 제외
    final explicit = _normalizeRegionSegment(filter.searchRgnSe);
    if (explicit != null && explicit.isNotEmpty && !_isEnglish(explicit)) {
      return explicit;
    }

    // 시/군 한국어만 허용
    final city = _normalizeRegionSegment(filter.city);
    if (city != null && city.isNotEmpty && !_isEnglish(city)) {
      return city;
    }

    // 읍/면/동 한국어만 허용
    final district = _normalizeRegionSegment(filter.district);
    if (district != null && district.isNotEmpty && !_isEnglish(district)) {
      return district;
    }

    // Explore 기본 = 경상북도
    return "경상북도";
  }

  // Explore 외 기존 로직
  final city = _normalizeRegionSegment(filter.city);
  final district = _normalizeRegionSegment(filter.district);

  if (city != null && city.isNotEmpty) {
    if (district != null && district.isNotEmpty) {
      return '$city|$district';
    }
    return city;
  }

  final effectiveRegion = filter.region == PolicyRegion.all
      ? settings.defaultRegion
      : filter.region;

  final mappedRegion = _mapRegionToKorean(effectiveRegion);
  if (mappedRegion != null && mappedRegion.isNotEmpty) {
    return mappedRegion;
  }

  return null;
}


String? _mapRegion(PolicyRegion region) {
  switch (region) {
    case PolicyRegion.seoul:
      return '서울특별시';
    case PolicyRegion.busan:
      return '부산광역시';
    case PolicyRegion.daegu:
      return '대구광역시';
    case PolicyRegion.incheon:
      return '인천광역시';
    case PolicyRegion.gwangju:
      return '광주광역시';
    case PolicyRegion.daejeon:
      return '대전광역시';
    case PolicyRegion.ulsan:
      return '울산광역시';
    case PolicyRegion.gyeongbuk:
      return '경상북도';
    case PolicyRegion.all:
      return null; // 전체는 null 처리 → explore에서는 override됨
  }
}

// 영어 문자열 체크
bool _isEnglish(String value) {
  final reg = RegExp(r'^[a-zA-Z]+$');
  return reg.hasMatch(value);
}


    // Explore 외 (즐겨찾기 등)에서만 사용
    final city = _normalizeRegionSegment(filter.city);
    final district = _normalizeRegionSegment(filter.district);

    if (city != null && city.isNotEmpty) {
      if (district != null && district.isNotEmpty) {
        return '$city|$district';
      }
      return city;
    }

    // 영어코드 → 한글 행정구역
    final effectiveRegion = filter.region == PolicyRegion.all
        ? settings.defaultRegion
        : filter.region;

    return _mapRegionToKorean(effectiveRegion);
  }

  String? _normalizeRegionSegment(String? v, {bool allowEmpty = false}) {
    if (v == null) return null;
    final trimmed = v.trim();
    if (trimmed.isEmpty || trimmed == '전체') return null;
    return trimmed;
  }

  /// 🔥 영어 region → 한글 행정구역으로 통일
  String? _mapRegionToKorean(PolicyRegion region) {
    switch (region) {
      case PolicyRegion.seoul:
        return '서울특별시';
      case PolicyRegion.busan:
        return '부산광역시';
      case PolicyRegion.daegu:
        return '대구광역시';
      case PolicyRegion.incheon:
        return '인천광역시';
      case PolicyRegion.gwangju:
        return '광주광역시';
      case PolicyRegion.daejeon:
        return '대전광역시';
      case PolicyRegion.ulsan:
        return '울산광역시';
      case PolicyRegion.gyeongbuk:
        return '경상북도';
      case PolicyRegion.all:
        return null;
    }
  }

  // ===========================================================
  // CACHE HELPERS
  // ===========================================================

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
