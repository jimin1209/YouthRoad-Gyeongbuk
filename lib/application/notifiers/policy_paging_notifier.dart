import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/policy_filter.dart';
import '../../domain/entities/policy.dart';
import 'package:youth_road_app/domain/policy/entities/policy_feed_type.dart';
import '../../domain/repositories/policy_repository.dart';
import '../di.dart';
import 'region_notifier.dart';

class PolicyPagingState {
  const PolicyPagingState({
    required this.items,
    required this.pageIndex,
    required this.filter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
  });

  final List<Policy> items;
  final int pageIndex;
  final PolicyFilter filter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;

  PolicyPagingState copyWith({
    List<Policy>? items,
    int? pageIndex,
    PolicyFilter? filter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
  }) {
    return PolicyPagingState(
      items: items ?? this.items,
      pageIndex: pageIndex ?? this.pageIndex,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

class PolicyFeedsState {
  const PolicyFeedsState({
    required this.primary,
    required this.recommended,
  });

  final PolicyPagingState primary;
  final PolicyPagingState recommended;

  PolicyFeedsState copyWith({
    PolicyPagingState? primary,
    PolicyPagingState? recommended,
  }) {
    return PolicyFeedsState(
      primary: primary ?? this.primary,
      recommended: recommended ?? this.recommended,
    );
  }
}

class PolicyFeedsNotifier extends AutoDisposeNotifier<PolicyFeedsState> {
  PolicyRepository get _repo => ref.read(policyRepositoryInterfaceProvider);

  static const String errorMessage = '정책을 불러오지 못했습니다. 다시 시도해 주세요.';
  static const String recommendedErrorMessage =
      '추천 정책을 불러오지 못했습니다. 다시 시도해 주세요.';
  static const int _pageSize = 10;

  bool _initialized = false;
  bool _initialLoadScheduled = false;

  int _primaryRequestId = 0;
  int _recommendedRequestId = 0;
  String? _primaryInFlightKey;
  String? _recommendedInFlightKey;

  PolicyPagingState get _primary => state.primary;
  PolicyPagingState get _recommended => state.recommended;

  PolicyFilter get currentFilter => _primary.filter;

  PolicyFeedType _effectiveFeed(PolicyFeedType feed) {
    return feed == PolicyFeedType.recommended
        ? PolicyFeedType.recommended
        : PolicyFeedType.primary;
  }

  @override
  PolicyFeedsState build() {
    if (!_initialized) {
      _initialized = true;
      final primaryFilter = _defaultFilter();
      final recommendedFilter = _recommendationFilter(primaryFilter);
      final initialState = PolicyFeedsState(
        primary: PolicyPagingState(
          items: const [],
          pageIndex: 1,
          filter: primaryFilter,
          isLoading: false,
          isLoadingMore: false,
          hasMore: true,
        ),
        recommended: PolicyPagingState(
          items: const [],
          pageIndex: 1,
          filter: recommendedFilter,
          isLoading: false,
          isLoadingMore: false,
          hasMore: true,
        ),
      );
      state = initialState;

      ref.listen<String?>(regionProvider, (previous, next) {
        if (previous == next) return;
        Future.microtask(() => loadInitial(PolicyFeedType.recommended));
      });

      if (!_initialLoadScheduled) {
        _initialLoadScheduled = true;
        Future.microtask(() async {
          await Future.wait([
            loadInitial(PolicyFeedType.primary),
            loadInitial(PolicyFeedType.recommended),
          ]);
        });
      }
      return initialState;
    }
    return state;
  }

  Future<void> loadInitial(PolicyFeedType feed, [PolicyFilter? filter]) async {
    final normalizedFeed = _effectiveFeed(feed);
    switch (normalizedFeed) {
      case PolicyFeedType.primary:
      case PolicyFeedType.bookmarked:
      case PolicyFeedType.latest:
        return _loadInitialPrimary(filter ?? _defaultFilter());
      case PolicyFeedType.recommended:
        return _loadInitialRecommended(filter ?? _recommendationFilter(_primary.filter));
    }
  }

  Future<void> _loadInitialPrimary(PolicyFilter filter) async {
    final normalized = _normalizePrimaryFilter(filter);
    final requestKey = _buildRequestKey(normalized, PolicyFeedType.primary);
    if (_primary.isLoading && requestKey == _primaryInFlightKey) {
      return;
    }
    _primaryInFlightKey = requestKey;

    state = state.copyWith(
      primary: _primary.copyWith(
        pageIndex: 1,
        filter: normalized,
        isLoading: true,
        isLoadingMore: false,
        hasMore: true,
        error: null,
      ),
    );

    await _loadFromCache(normalized, PolicyFeedType.primary);
    await _fetch(
      feed: PolicyFeedType.primary,
      pageIndex: 1,
      append: false,
      filter: normalized,
    );
    _primaryInFlightKey = null;
  }

  Future<void> _loadInitialRecommended(PolicyFilter filter) async {
    final normalized = _normalizeRecommendedFilter(filter);
    final requestKey = _buildRequestKey(normalized, PolicyFeedType.recommended);
    if (_recommended.isLoading && requestKey == _recommendedInFlightKey) {
      return;
    }
    _recommendedInFlightKey = requestKey;

    state = state.copyWith(
      recommended: _recommended.copyWith(
        pageIndex: 1,
        filter: normalized,
        isLoading: true,
        isLoadingMore: false,
        hasMore: true,
        error: null,
      ),
    );

    await _loadFromCache(normalized, PolicyFeedType.recommended);
    await _fetch(
      feed: PolicyFeedType.recommended,
      pageIndex: 1,
      append: false,
      filter: normalized,
    );
    _recommendedInFlightKey = null;
  }

  Future<void> loadMore(PolicyFeedType feed) async {
    final normalizedFeed = _effectiveFeed(feed);
    switch (normalizedFeed) {
      case PolicyFeedType.primary:
      case PolicyFeedType.bookmarked:
      case PolicyFeedType.latest:
        if (_primary.isLoadingMore || _primary.isLoading || !_primary.hasMore) {
          return;
        }
        final nextPage = _primary.pageIndex + 1;
        await _fetch(
          feed: PolicyFeedType.primary,
          pageIndex: nextPage,
          append: true,
          filter: _primary.filter,
        );
        break;
      case PolicyFeedType.recommended:
        if (_recommended.isLoadingMore ||
            _recommended.isLoading ||
            !_recommended.hasMore) {
          return;
        }
        final nextPage = _recommended.pageIndex + 1;
        await _fetch(
          feed: PolicyFeedType.recommended,
          pageIndex: nextPage,
          append: true,
          filter: _recommended.filter,
        );
        break;
    }
  }

  void updatePrimaryFilter(PolicyFilter filter) {
    final normalized = _normalizePrimaryFilter(filter);
    _loadInitialPrimary(normalized);
  }

  Future<void> refreshAll(PolicyFilter filter) async {
    await Future.wait([
      _loadInitialPrimary(filter),
      _loadInitialRecommended(_recommendationFilter(filter)),
    ]);
  }

  Future<void> seedFromCache(List<Policy> policies) async {
    final limited = policies.take(_pageSize).toList();
    state = state.copyWith(
      primary: _primary.copyWith(
        items: limited,
        pageIndex: 1,
        hasMore: policies.length >= _pageSize,
        isLoading: _primary.isLoading,
        error: null,
      ),
    );
  }

  Future<void> replaceWithFresh(List<Policy> policies) async {
    state = state.copyWith(
      primary: _primary.copyWith(
        items: policies.take(_pageSize).toList(),
        pageIndex: 1,
        hasMore: policies.length >= _pageSize,
        isLoading: false,
        isLoadingMore: false,
        error: null,
      ),
    );
  }

  Future<void> _loadFromCache(PolicyFilter filter, PolicyFeedType feed) async {
    final normalizedFeed = _effectiveFeed(feed);
    try {
      final cached = await _repo.loadCachedPolicies(filter: filter);
      if (cached.isNotEmpty) {
        await _seedFeedFromCache(normalizedFeed, cached);
      }
    } catch (e, st) {
      debugPrint('[PolicyFeedsNotifier] cache fallback failed: $e\n$st');
    }
  }

  Future<void> _seedFeedFromCache(
    PolicyFeedType feed,
    List<Policy> policies,
  ) async {
    final normalizedFeed = _effectiveFeed(feed);
    final limited = policies.take(_pageSize).toList();
    switch (normalizedFeed) {
      case PolicyFeedType.primary:
      case PolicyFeedType.bookmarked:
      case PolicyFeedType.latest:
        state = state.copyWith(
          primary: _primary.copyWith(
            items: limited,
            pageIndex: 1,
            hasMore: policies.length >= _pageSize,
            isLoading: _primary.isLoading,
            error: null,
          ),
        );
        break;
      case PolicyFeedType.recommended:
        state = state.copyWith(
          recommended: _recommended.copyWith(
            items: limited,
            pageIndex: 1,
            hasMore: policies.length >= _pageSize,
            isLoading: _recommended.isLoading,
            error: null,
          ),
        );
        break;
    }
  }

  Future<void> _fetch({
    required PolicyFeedType feed,
    required int pageIndex,
    required bool append,
    required PolicyFilter filter,
  }) async {
    final normalizedFeed = _effectiveFeed(feed);
    final requestId = normalizedFeed == PolicyFeedType.primary
        ? ++_primaryRequestId
        : ++_recommendedRequestId;

    state = state.copyWith(
      primary: normalizedFeed == PolicyFeedType.primary
          ? _primary.copyWith(
              isLoading: !append,
              isLoadingMore: append,
              error: null,
            )
          : _primary,
      recommended: normalizedFeed == PolicyFeedType.recommended
          ? _recommended.copyWith(
              isLoading: !append,
              isLoadingMore: append,
              error: null,
            )
          : _recommended,
    );

    try {
      final policies = await _repo.refreshPolicies(
        filter: filter.copyWith(
          pageIndex: pageIndex,
          recordCount: _pageSize,
          pagingYn: 'Y',
          availableOnly: normalizedFeed == PolicyFeedType.recommended
              ? true
              : filter.availableOnly,
        ),
      );

      final mergedItems = append
          ? [...(normalizedFeed == PolicyFeedType.primary ? _primary.items : _recommended.items), ...policies]
          : policies;
      final hasMore = policies.length >= _pageSize;

      if (normalizedFeed == PolicyFeedType.primary) {
        if (requestId != _primaryRequestId) return;
        state = state.copyWith(
          primary: _primary.copyWith(
            items: mergedItems,
            pageIndex: pageIndex,
            filter: filter.copyWith(pageIndex: pageIndex),
            isLoading: false,
            isLoadingMore: false,
            hasMore: hasMore,
            error: null,
          ),
        );
      } else {
        if (requestId != _recommendedRequestId) return;
        state = state.copyWith(
          recommended: _recommended.copyWith(
            items: mergedItems,
            pageIndex: pageIndex,
            filter: filter.copyWith(pageIndex: pageIndex),
            isLoading: false,
            isLoadingMore: false,
            hasMore: hasMore,
            error: null,
          ),
        );
      }
    } catch (e, st) {
      debugPrint('Failed to load policies: $e');
      debugPrint('$st');
      if (normalizedFeed == PolicyFeedType.primary) {
        if (requestId != _primaryRequestId) return;
        state = state.copyWith(
          primary: _primary.copyWith(
            isLoading: false,
            isLoadingMore: false,
            error: errorMessage,
          ),
        );
      } else {
        if (requestId != _recommendedRequestId) return;
        state = state.copyWith(
          recommended: _recommended.copyWith(
            isLoading: false,
            isLoadingMore: false,
            error: recommendedErrorMessage,
          ),
        );
      }
    }
  }

  PolicyFilter _defaultFilter() {
    final region = ref.read(regionProvider);
    return PolicyFilter(
      searchRgnSe: region,
      availableOnly: true,
      pageIndex: 1,
      recordCount: _pageSize,
      pagingYn: 'Y',
    );
  }

  PolicyFilter _recommendationFilter(PolicyFilter base) {
    final region = base.searchRgnSe ?? ref.read(regionProvider);
    return PolicyFilter(
      searchRgnSe: region,
      availableOnly: true,
      pageIndex: 1,
      recordCount: _pageSize,
      pagingYn: 'Y',
    );
  }

  PolicyFilter _normalizePrimaryFilter(PolicyFilter filter) {
    final region = filter.searchRgnSe ?? ref.read(regionProvider);
    return filter.copyWith(
      searchRgnSe: region,
      availableOnly: filter.availableOnly ?? true,
      pageIndex: 1,
      recordCount: _pageSize,
      pagingYn: 'Y',
    );
  }

  PolicyFilter _normalizeRecommendedFilter(PolicyFilter filter) {
    final region = filter.searchRgnSe ?? ref.read(regionProvider);
    return filter.copyWith(
      searchRgnSe: region,
      availableOnly: true,
      pageIndex: 1,
      recordCount: _pageSize,
      pagingYn: 'Y',
    );
  }

  String _buildRequestKey(PolicyFilter filter, PolicyFeedType feed) {
    final normalizedFeed = _effectiveFeed(feed);
    final normalized = PolicyFilter(
      searchRgnSe: filter.searchRgnSe,
      searchPolicyType: filter.searchPolicyType,
      searchPolicyNm:
          normalizedFeed == PolicyFeedType.recommended ? null : filter.searchPolicyNm,
      searchText: normalizedFeed == PolicyFeedType.recommended ? null : filter.searchText,
      category: filter.category,
      searchYear: filter.searchYear,
      instNo: filter.instNo,
      deptNo: filter.deptNo,
      startDate: filter.startDate,
      endDate: filter.endDate,
      availableOnly:
          normalizedFeed == PolicyFeedType.recommended ? true : filter.availableOnly,
      pageIndex: filter.pageIndex ?? 1,
      recordCount: filter.recordCount ?? _pageSize,
      pageSize: filter.pageSize,
      pagingYn: filter.pagingYn ?? 'Y',
      searchDsplyYn: filter.searchDsplyYn ?? 'all',
    );

    return jsonEncode(normalized.toJson());
  }
}
