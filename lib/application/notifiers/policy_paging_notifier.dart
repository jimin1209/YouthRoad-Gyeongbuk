import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/policy_filter.dart';
import '../../domain/entities/policy.dart';
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

class PolicyPagingNotifier extends AutoDisposeNotifier<PolicyPagingState> {
  PolicyRepository get _repo => ref.read(policyRepositoryProvider);

  static const String errorMessage = '정책을 불러오지 못했습니다. 다시 시도해 주세요.';
  static const int _pageSize = 10;

  bool _initialized = false;
  int _requestId = 0;
  String? _inFlightKey;

  PolicyFilter get currentFilter => state.filter;

  @override
  PolicyPagingState build() {
    if (!_initialized) {
      _initialized = true;
      final filter = PolicyFilter(
        searchRgnSe: ref.read(regionProvider),
        pageIndex: 1,
        recordCount: _pageSize,
        pagingYn: 'Y',
      );
      final initialState = PolicyPagingState(
        items: const [],
        pageIndex: 1,
        filter: filter,
        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
      );
      state = initialState;
      return initialState;
    }
    return state;
  }

  Future<void> loadInitial(PolicyFilter filter) async {
    final mergedFilter = _normalizeFilter(filter);
    final requestKey = _buildRequestKey(mergedFilter);
    if (state.isLoading && requestKey == _inFlightKey) {
      return;
    }
    _inFlightKey = requestKey;

    state = state.copyWith(
      items: state.items,
      pageIndex: 1,
      filter: mergedFilter,
      isLoading: true,
      isLoadingMore: false,
      hasMore: true,
      error: null,
    );

    await _loadFromCache(mergedFilter);
    await _fetch(pageIndex: 1, append: false, filter: mergedFilter);
    _inFlightKey = null;
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.isLoading || !state.hasMore) return;
    final nextPage = state.pageIndex + 1;
    await _fetch(pageIndex: nextPage, append: true, filter: state.filter);
  }

  void updateFilter(PolicyFilter filter) {
    final normalized = _normalizeFilter(filter);
    loadInitial(normalized);
  }

  Future<void> seedFromCache(List<Policy> policies) async {
    final limited = policies.take(_pageSize).toList();
    state = state.copyWith(
      items: limited,
      pageIndex: 1,
      hasMore: policies.length >= _pageSize,
      isLoading: state.isLoading,
      error: null,
    );
  }

  Future<void> replaceWithFresh(List<Policy> policies) async {
    state = state.copyWith(
      items: policies.take(_pageSize).toList(),
      pageIndex: 1,
      hasMore: policies.length >= _pageSize,
      isLoading: false,
      isLoadingMore: false,
      error: null,
    );
  }

  Future<void> _loadFromCache(PolicyFilter filter) async {
    try {
      final cached = await ref
          .read(hybridPolicyRepositoryProvider)
          .loadCachedPolicies(filter: filter);
      if (cached.isNotEmpty) {
        await seedFromCache(cached);
      }
    } catch (e, st) {
      debugPrint('[PolicyPagingNotifier] cache fallback failed: $e\n$st');
    }
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
      final policies = await _repo.fetchPolicies(
        filter: filter.copyWith(
          pageIndex: pageIndex,
          recordCount: _pageSize,
          pagingYn: 'Y',
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
      debugPrint('Failed to load policies: $e');
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
      pageIndex: 1,
      recordCount: _pageSize,
      pagingYn: 'Y',
    );
  }

  String _buildRequestKey(PolicyFilter filter) {
    final normalized = PolicyFilter(
      searchRgnSe: filter.searchRgnSe,
      searchPolicyType: filter.searchPolicyType,
      searchPolicyNm: filter.searchPolicyNm,
      searchText: filter.searchText,
      category: filter.category,
      searchYear: filter.searchYear,
      instNo: filter.instNo,
      deptNo: filter.deptNo,
      startDate: filter.startDate,
      endDate: filter.endDate,
      availableOnly: filter.availableOnly,
      pageIndex: filter.pageIndex ?? 1,
      recordCount: filter.recordCount ?? _pageSize,
      pageSize: filter.pageSize,
      pagingYn: filter.pagingYn ?? 'Y',
      searchDsplyYn: filter.searchDsplyYn ?? 'all',
    );

    return jsonEncode(normalized.toJson());
  }
}
