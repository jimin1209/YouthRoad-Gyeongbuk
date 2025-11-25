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

  @override
  PolicyPagingState build() {
    final region = ref.watch(regionProvider);

    if (!_initialized) {
      _initialized = true;
      final filter = PolicyFilter(
        searchRgnSe: region,
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
      loadInitial(filter);
      return initialState;
    }

    if (state.filter.searchRgnSe != region) {
      updateFilter(state.filter.copyWith(searchRgnSe: region, pageIndex: 1));
    }

    return state;
  }

  Future<void> loadInitial(PolicyFilter filter) async {
    final mergedFilter = filter.copyWith(
      searchRgnSe: filter.searchRgnSe ?? ref.read(regionProvider),
      pageIndex: 1,
      recordCount: _pageSize,
      pagingYn: 'Y',
    );

    state = state.copyWith(
      items: const [],
      pageIndex: 1,
      filter: mergedFilter,
      isLoading: true,
      isLoadingMore: false,
      hasMore: true,
      error: null,
    );

    await _fetch(pageIndex: 1, append: false, filter: mergedFilter);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.isLoading || !state.hasMore) return;
    final nextPage = state.pageIndex + 1;
    await _fetch(pageIndex: nextPage, append: true, filter: state.filter);
  }

  void updateFilter(PolicyFilter filter) {
    final normalized = filter.copyWith(
      searchRgnSe: filter.searchRgnSe ?? ref.read(regionProvider),
      pageIndex: 1,
      recordCount: _pageSize,
      pagingYn: 'Y',
    );
    loadInitial(normalized);
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
}
