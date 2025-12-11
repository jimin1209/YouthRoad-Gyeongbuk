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
  //  PARAM BUILDING
  // ===========================================================
  Map<String, dynamic> _buildQueryParameters({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) {
    final sanitizedQuery = _sanitizeQueryForExplore(query);
    final normalized = sanitizedQuery.normalize();
    final filter = normalized.filter;

    final normalizedPage = page < 1 ? 1 : page;
    final normalizedSize = pageSize <= 0 ? settings.pageSize : pageSize;

    final params = <String, dynamic>{
      'pageIndex': normalizedPage,
      'pageSize': normalizedSize,
      'recordCount': normalizedSize,
      'pagingYn': 'Y',

      // Explore = 반드시 Y
      'searchDsplyYn': _isExploreFeed(normalized.feedType) ? 'Y' : 'all',

      'feed_type': normalized.feedType.name,
      'sort': normalized.sort.name,
    };

    // 키워드
    if (normalized.keyword != null && normalized.keyword!.isNotEmpty) {
      params['searchPolicyNm'] = normalized.keyword;
    }

// REGION
    final isExplore = _isExploreFeed(normalized.feedType);
    final regionValue = _regionParam(filter, explore: isExplore);

// Explore는 searchRgnSe 제거 → 전체 조회 강제
    if (!isExplore) {
      if (regionValue != null && regionValue.isNotEmpty) {
        params['searchRgnSe'] = regionValue;
      }
    }

    // STATUS
    final statusValue = _mapStatusParam(filter.status);
    if (statusValue != null) {
      params['status'] = statusValue;
    }

    // CATEGORY
    if (filter.category != null) {
      params['searchPolicyType'] = _mapCategory(filter.category!);
    }

    // 온라인 여부
    if (filter.isOnline != null) {
      params['aplyYn'] = filter.isOnline! ? 'Y' : 'N';
    }

    // 기관
    if (filter.institutionId != null && filter.institutionId!.isNotEmpty) {
      params['instNo'] = filter.institutionId;
    }

    // 부서
    if (filter.departmentId != null && filter.departmentId!.isNotEmpty) {
      params['deptNo'] = filter.departmentId;
    }

    // TAGS
    if (normalized.tags.isNotEmpty) {
      params['tags'] = normalized.tags.join(',');
    }
    if (filter.tags.isNotEmpty) {
      params['filterTags'] = filter.tags.join(',');
    }

    _sanitizeParams(params);
    return params;
  }

  // searchRgnSe 제거 금지
  void _sanitizeParams(Map<String, dynamic> params) {
    params.removeWhere((key, value) {
      if (key == 'searchRgnSe') return false;
      if (key == 'status') return value == null;

      if (value == null) return true;
      if (value is String) {
        final t = value.trim();
        if (t.isEmpty) return true;
        if (key == "searchPolicyType" && t.toLowerCase() == "all") {
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
    final size = pageSize == 0 ? settings.pageSize : pageSize;

    if (settings.enableCache) {
      final cacheResult = _tryReturnCache(
        cache.getPageWithStatus(page, settings.cacheTtl),
        () => _fetchAndCacheDefault(page, size),
      );
      if (cacheResult != null) return cacheResult;
    }

    debugPrint('[CACHE:MISS]');
    return _fetchAndCacheDefault(page, size);
  }

  @override
  Future<PolicyResult<List<Policy>>> fetchPoliciesByQuery({
    required PolicyQuery query,
    required int page,
    required int pageSize,
  }) async {
    final sanitized = _sanitizeQueryForExplore(query);
    final normalized = sanitized.normalize();

    final size = pageSize == 0 ? settings.pageSize : pageSize;
    final scopeKey = normalized.cacheScopeKey;

    // ID 기반 조회 (즐겨찾기/비교)
    if (_isIdBasedQuery(normalized)) {
      if (settings.enableCache) {
        final cacheResult = _tryReturnCache(
          cache.getPageWithStatus(page, settings.cacheTtl, scope: scopeKey),
          () => _fetchAndCacheByIds(
            query: normalized,
            page: page,
            pageSize: size,
            scopeKey: scopeKey,
          ),
        );
        if (cacheResult != null) return cacheResult;
      }

      debugPrint('[CACHE:MISS]');
      return _fetchAndCacheByIds(
        query: normalized,
        page: page,
        pageSize: size,
        scopeKey: scopeKey,
      );
    }

    // 일반 Explore 조회
    if (settings.enableCache) {
      final cacheResult = _tryReturnCache(
        cache.getPageWithStatus(page, settings.cacheTtl, scope: scopeKey),
        () => _fetchAndCacheQuery(
          query: normalized,
          page: page,
          pageSize: size,
          scopeKey: scopeKey,
        ),
      );
      if (cacheResult != null) return cacheResult;
    }

    debugPrint('[CACHE:MISS]');
    return _fetchAndCacheQuery(
      query: normalized,
      page: page,
      pageSize: size,
      scopeKey: scopeKey,
    );
  }

  // -----------------------------------------------------------
  // DEFAULT FETCH
  // -----------------------------------------------------------
  Future<PolicyResult<List<Policy>>> _fetchAndCacheDefault(
    int page,
    int pageSize,
  ) async {
    final filter = PolicyFilter(region: PolicyRegion.all);
    final query = PolicyQuery(filter: filter, feedType: PolicyFeedType.all);
    final sanitized = _sanitizeQueryForExplore(query);

    final result = await _fetchFromRemote(
      query: sanitized,
      page: page,
      pageSize: pageSize,
    );

    if (settings.enableCache && result.isSuccess && result.data != null) {
      cache.savePage(page, result.data!);
      cache.savePageForScope(sanitized.cacheScopeKey, page, result.data!);
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
    final sanitized = _sanitizeQueryForExplore(query);
    final normalized = sanitized.normalize();
    final f = normalized.filter;

    try {
      logger.info(
        '[Explore][INFO] fetchPoliciesByQuery(scope: $scopeKey, '
        'region: ${f.region.name}/${f.province}/${f.city ?? '-'} (${f.district ?? '-'}), '
        'status: ${f.status.queryValue}, sort: ${normalized.sort.name}, '
        'keyword: ${normalized.keyword ?? '-'}, feed: ${normalized.feedType.name}, '
        'page: $page, size: $pageSize)',
      );

      final result = await _fetchFromRemote(
        query: normalized,
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
    if (ids.isEmpty) return PolicyResult.success(<Policy>[]);

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
    final sanitized = _sanitizeQueryForExplore(query);
    final scopeKey = sanitized.cacheScopeKey;

    final params = _buildQueryParameters(
      query: sanitized,
      page: page,
      pageSize: pageSize,
    );

    debugPrint('[Explore][Sanitized Params] $params');

    if (_isExploreFeed(sanitized.feedType)) {
      debugPrint(
        '[Policy][Explore][FETCH] status=${sanitized.filter.status.queryValue}, '
        'category=${sanitized.filter.category?.name ?? 'null'}, '
        'keyword=${sanitized.keyword ?? '-'}, page=$page, size=$pageSize',
      );
    }

    try {
      logger.info(
        '원격 데이터 수신 요청 (scope: $scopeKey, page: $page, params: ${_debugParams(params)})',
      );

      final models = await remote.fetchPoliciesWithParams(params);
      final domain = models.map((e) => e.toDomain()).toList();

      // 필터 적용
      final statusFiltered = _applyStatusFilter(sanitized.filter, domain);
      final tagFiltered = _isIdBasedQuery(sanitized)
          ? statusFiltered
          : _applyTagFilter(sanitized, statusFiltered);
      final sorted = _applySorting(sanitized.sort, tagFiltered);

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

  // -----------------------------------------------------------
  // DETAIL FETCH
  // -----------------------------------------------------------
  @override
  Future<PolicyResult<Policy>> fetchPolicyDetail(String id) async {
    try {
      final model = await remote.fetchPolicyDetail(id);
      return PolicyResult.success(model.toDomain());
    } catch (e, st) {
      logger.error('정책 상세 조회 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }

  // -----------------------------------------------------------
  // CATEGORY MAPPING
  // -----------------------------------------------------------
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

  // -----------------------------------------------------------
  // LOAD BY IDS
  // -----------------------------------------------------------
  Future<PolicyResult<List<Policy>>> _loadPoliciesByIds({
    required List<String> ids,
    required int page,
    required int pageSize,
    required String scopeKey,
  }) async {
    try {
      final models = await remote.fetchPoliciesByIds(ids);
      final list = models.map((e) => e.toDomain()).toList();
      return PolicyResult.success(list);
    } catch (e, st) {
      logger.error('_loadPoliciesByIds 실패', e, st);
      if (e is PolicyFailure) return PolicyResult.failure(e);
      return PolicyResult.failure(const UnknownFailure());
    }
  }

  // ===========================================================
  // TAG FILTER / SORT
  // ===========================================================
  bool _isIdBasedQuery(PolicyQuery q) =>
      q.feedType == PolicyFeedType.favorite ||
      q.feedType == PolicyFeedType.bookmarked ||
      q.feedType == PolicyFeedType.compare;

  List<Policy> _applyStatusFilter(PolicyFilter filter, List<Policy> list) {
    if (filter.status == PolicyStatusFilter.includeClosed) return list;

    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final today = DateTime(now.year, now.month, now.day);

    bool ongoing(Policy p) {
      final s = p.applicationStartDate;
      final e = p.applicationEndDate;
      final sd = s == null ? null : DateTime(s.year, s.month, s.day);
      final ed = e == null ? null : DateTime(e.year, e.month, e.day);

      final started = sd == null || !sd.isAfter(today);
      final notEnded = ed == null || !ed.isBefore(today);
      return started && notEnded;
    }

    bool closed(Policy p) {
      final e = p.applicationEndDate;
      if (e == null) return false;
      final ed = DateTime(e.year, e.month, e.day);
      return ed.isBefore(today);
    }

    return list.where((p) {
      if (filter.status == PolicyStatusFilter.inProgressOnly) return ongoing(p);
      return closed(p);
    }).toList();
  }

  List<Policy> _applyTagFilter(PolicyQuery query, List<Policy> list) {
    final tags = {...query.tags, ...query.filter.tags}
      ..removeWhere((e) => e.trim().isEmpty);
    if (tags.isEmpty) return list;

    return list.where((p) {
      final text = '${p.title} ${p.summary} ${p.institution} ${p.department}'
          .toLowerCase();
      return tags.any((tag) => text.contains(tag.toLowerCase()));
    }).toList();
  }

  List<Policy> _applySorting(PolicySortOption sort, List<Policy> list) {
    final sorted = List<Policy>.from(list);

    int desc(DateTime? a, DateTime? b) {
      if (a == null && b == null) return 0;
      if (a == null) return 1;
      if (b == null) return -1;
      return b.compareTo(a);
    }

    DateTime? pick(DateTime? a, DateTime? b) => a ?? b;

    switch (sort) {
      case PolicySortOption.latest:
        sorted.sort((a, b) => desc(
            pick(a.createdAt, a.updatedAt), pick(b.createdAt, b.updatedAt)));
        break;
      case PolicySortOption.recommendation:
        sorted.sort((a, b) => desc(
            pick(a.updatedAt, a.createdAt), pick(b.updatedAt, b.createdAt)));
        break;
      case PolicySortOption.deadline:
        sorted.sort((a, b) {
          final ea = a.applicationEndDate;
          final eb = b.applicationEndDate;
          if (ea == null && eb == null) return 0;
          if (ea == null) return 1;
          if (eb == null) return -1;
          return ea.compareTo(eb);
        });
        break;
      case PolicySortOption.popularity:
        sorted.sort((a, b) => desc(pick(a.applicationStartDate, a.createdAt),
            pick(b.applicationStartDate, b.createdAt)));
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

  /// Explore 쿼리는 무조건 한국어 searchRgnSe 사용 (서버 요구사항)
  String _mapSearchRgnSeForExplore(
    PolicyFilter filter,
    PolicyFeedType feedType,
  ) {
    final explicit = _normalizeRegionSegment(filter.searchRgnSe);
    if (explicit != null && explicit.isNotEmpty && !_isEnglish(explicit)) {
      return explicit;
    }

    final city = _normalizeRegionSegment(filter.city);
    if (city != null && city.isNotEmpty && !_isEnglish(city)) return city;

    final district = _normalizeRegionSegment(filter.district);
    if (district != null && district.isNotEmpty && !_isEnglish(district)) {
      return district;
    }

    // 기본값
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

  // ===========================================================
  // REGION PARAM (한국어 우선)
  // ===========================================================
  String? _regionParam(
    PolicyFilter filter, {
    bool explore = false,
  }) {
    if (explore) {
      final explicit = _normalizeRegionSegment(filter.searchRgnSe);
      if (explicit != null && explicit.isNotEmpty && !_isEnglish(explicit)) {
        return explicit;
      }

      final city = _normalizeRegionSegment(filter.city);
      if (city != null && city.isNotEmpty && !_isEnglish(city)) return city;

      final district = _normalizeRegionSegment(filter.district);
      if (district != null && district.isNotEmpty && !_isEnglish(district)) {
        return district;
      }

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

    // 영어 Region → 한국어 Region으로 매핑
    final effectiveRegion = filter.region == PolicyRegion.all
        ? settings.defaultRegion
        : filter.region;

    return _mapRegionToKorean(effectiveRegion);
  }

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

  bool _isEnglish(String value) {
    final reg = RegExp(r'^[a-zA-Z]+$');
    return reg.hasMatch(value);
  }

  String? _normalizeRegionSegment(String? v, {bool allowEmpty = false}) {
    if (v == null) return null;
    final trimmed = v.trim();
    if (trimmed.isEmpty || trimmed == '전체') return null;
    return trimmed;
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
