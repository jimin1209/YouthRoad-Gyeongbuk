import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/policy_filter.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../di.dart';
import 'policy_paging_notifier.dart';
import 'region_notifier.dart';

class RecommendedPolicyNotifier
    extends AutoDisposeNotifier<PolicyPagingState> {
  PolicyRepository get _repository => ref.read(policyRepositoryInterfaceProvider);

  static const String errorMessage = '추천 정책을 불러오지 못했습니다. 다시 시도해 주세요.';
  static const int _pageSize = 10;

  bool _initialized = false;
  bool _initialLoadScheduled = false;
  int _requestId = 0;
  String? _inFlightKey;

  @override
  PolicyPagingState build() {
    if (!_initialized) {
      _initialized = true;
      final filter = _baseFilter();
      final initialState = PolicyPagingState(
        items: const [],
        pageIndex: 1,
        filter: filter,
        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
      );
      state = initialState;
      ref.listen<String?>(regionProvider, (previous, next) {
        if (previous == next) return;
        Future.microtask(() => loadInitial(_baseFilter()));
      });
      if (!_initialLoadScheduled) {
        _initialLoadScheduled = true;
        Future.microtask(() => loadInitial(filter));
      }
      return initialState;
    }
    return state;
  }

  PolicyFilter _baseFilter() {
    final region = ref.read(regionProvider);
    return PolicyFilter(
      searchRgnSe: region,
      availableOnly: true,
      pageIndex: 1,
      recordCount: _pageSize,
      pagingYn: 'Y',
    );
  }

  Future<void> loadInitial([PolicyFilter? filter]) async {
    final normalizedFilter = _normalizeFilter(filter ?? _baseFilter());
    final requestKey = _buildRequestKey(normalizedFilter);
    if (state.isLoading && requestKey == _inFlightKey) {
      return;
    }
    _inFlightKey = requestKey;

    state = state.copyWith(
      items: state.items,
      pageIndex: 1,
      filter: normalizedFilter,
      isLoading: true,
      isLoadingMore: false,
      hasMore: true,
      error: null,
    );

    await _loadFromCache(normalizedFilter);
    await _fetch(pageIndex: 1, append: false, filter: normalizedFilter);
    _inFlightKey = null;
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.isLoading || !state.hasMore) return;
    final nextPage = state.pageIndex + 1;
    await _fetch(pageIndex: nextPage, append: true, filter: state.filter);
  }

  Future<void> retry() async {
    await loadInitial(state.filter);
  }

  Future<void> _loadFromCache(PolicyFilter filter) async {
    try {
      final cached = await _repository.loadCachedPolicies(filter: filter);
      if (cached.isNotEmpty) {
        await _seedFromCache(cached);
      }
    } catch (e, st) {
      debugPrint('[RecommendedPolicyNotifier] cache fallback failed: $e\n$st');
    }
  }

  Future<void> _seedFromCache(List<Policy> policies) async {
    final limited = policies.take(_pageSize).toList();
    state = state.copyWith(
      items: limited,
      pageIndex: 1,
      hasMore: policies.length >= _pageSize,
      isLoading: state.isLoading,
      error: null,
    );
  }

  Future<void> _fetch({
    required int pageIndex,
    required bool append,
    required PolicyFilter filter,
  }) async {
    final requestId = ++_requestId;
    state = state.copyWith(
      isLoading: !append,
      isLoadingMore: append,
      error: null,
    );

    try {
      final policies = await _repository.refreshPolicies(
        filter: filter.copyWith(
          pageIndex: pageIndex,
          recordCount: _pageSize,
          pagingYn: 'Y',
          availableOnly: true,
        ),
      );

      if (requestId != _requestId) return;

      final mergedItems = append ? [...state.items, ...policies] : policies;
      final hasMore = policies.length >= _pageSize;

      state = state.copyWith(
        items: mergedItems,
        pageIndex: pageIndex,
        filter: filter.copyWith(pageIndex: pageIndex),
        isLoading: false,
        isLoadingMore: false,
        hasMore: hasMore,
        error: null,
      );
    } catch (e, st) {
      debugPrint('Failed to load recommended policies: $e');
      debugPrint('$st');
      if (requestId != _requestId) return;
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: errorMessage,
      );
    }
  }

  PolicyFilter _normalizeFilter(PolicyFilter filter) {
    final region = filter.searchRgnSe ?? ref.read(regionProvider);
    return filter.copyWith(
      searchRgnSe: region,
      availableOnly: true,
      pageIndex: 1,
      recordCount: _pageSize,
      pagingYn: 'Y',
    );
  }

  String _buildRequestKey(PolicyFilter filter) {
    final normalized = PolicyFilter(
      searchRgnSe: filter.searchRgnSe,
      searchPolicyType: filter.searchPolicyType,
      searchPolicyNm: null,
      searchText: null,
      category: filter.category,
      searchYear: filter.searchYear,
      instNo: filter.instNo,
      deptNo: filter.deptNo,
      startDate: filter.startDate,
      endDate: filter.endDate,
      availableOnly: true,
      pageIndex: filter.pageIndex ?? 1,
      recordCount: filter.recordCount ?? _pageSize,
      pageSize: filter.pageSize,
      pagingYn: filter.pagingYn ?? 'Y',
      searchDsplyYn: filter.searchDsplyYn ?? 'all',
    );

    return jsonEncode(normalized.toJson());
  }
}

final recommendedPolicyProvider =
    NotifierProvider.autoDispose<RecommendedPolicyNotifier, PolicyPagingState>(
  RecommendedPolicyNotifier.new,
);
