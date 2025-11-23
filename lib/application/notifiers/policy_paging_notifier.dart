import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/policy_filter.dart';
import '../../data/sources/local/search_history_source.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../di.dart';
import 'region_notifier.dart';

class PolicyPagingState {
  const PolicyPagingState({
    required this.items,
    required this.page,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.initialLoaded = false,
  });

  final List<Policy> items;
  final int page;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final bool initialLoaded;

  PolicyPagingState copyWith({
    List<Policy>? items,
    int? page,
    bool? isLoading,
    bool? hasMore,
    String? error,
    bool? initialLoaded,
  }) {
    return PolicyPagingState(
      items: items ?? this.items,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      initialLoaded: initialLoaded ?? this.initialLoaded,
    );
  }
}

class PolicyPagingNotifier extends AutoDisposeNotifier<PolicyPagingState> {
  late final PolicyRepository _repo;
  int _requestId = 0;
  String? _currentRegion;
  String? _searchQuery;
  static const String errorMessage = '정책을 불러오지 못했습니다. 다시 시도해 주세요.';

  @override
  PolicyPagingState build() {
    _repo = ref.read(policyRepositoryProvider);
    _currentRegion = ref.read(regionProvider);
    ref.listen<String?>(regionProvider, (previous, next) {
      if (previous == next) return;
      _currentRegion = next;
      _resetAndLoad();
    });
    const initialState = PolicyPagingState(
      items: [],
      page: 1,
      isLoading: false,
      hasMore: true,
      initialLoaded: false,
    );
    state = initialState;
    _resetAndLoad();
    return initialState;
  }

  void _resetAndLoad() {
    state = state.copyWith(
      items: const [],
      page: 1,
      hasMore: true,
      error: null,
      isLoading: false,
      initialLoaded: false,
    );
    loadMore(reset: true);
  }

  Future<void> loadMore({bool reset = false}) async {
    if (state.isLoading || (!reset && !state.hasMore)) return;

    final nextPage = reset ? 1 : state.page + 1;
    final currentRegion = _currentRegion ?? ref.read(regionProvider);
    final currentRequestId = ++_requestId;
    final previousItems = reset ? <Policy>[] : state.items;

    state = state.copyWith(
      items: reset ? const [] : state.items,
      page: nextPage,
      isLoading: true,
      error: null,
      hasMore: reset ? true : state.hasMore,
      initialLoaded: reset ? false : state.initialLoaded,
    );

    try {
      final List<Policy> newItems = await _repo.fetchPolicies(
        filter: PolicyFilter(
          searchRgnSe: currentRegion,
          searchPolicyNm: _searchQuery,
          pageIndex: nextPage,
          recordCount: 10,
        ),
      );
      if (_requestId != currentRequestId) return;

      final merged = <Policy>[...previousItems, ...newItems];
      state = state.copyWith(
        items: merged,
        page: nextPage,
        isLoading: false,
        hasMore: newItems.isNotEmpty,
        initialLoaded: true,
      );
    } catch (e, st) {
      debugPrint('Failed to load policy list: $e');
      debugPrint('$st');
      if (_requestId != currentRequestId) return;
      state = state.copyWith(
        items: previousItems,
        page: reset ? 1 : state.page,
        isLoading: false,
        hasMore: reset ? true : state.hasMore,
        error: errorMessage,
        initialLoaded: reset ? false : state.initialLoaded,
      );
    }
  }

  Future<void> search(String query) async {
    final normalized = query.trim();
    _searchQuery = normalized.isEmpty ? null : normalized;
    // === 보완 패치: 검색 히스토리 저장 ===
    if (_searchQuery != null) {
      final history = ref.read(searchHistorySourceProvider);
      await history.saveQuery(_searchQuery!);
      ref.invalidate(searchHistoryListProvider);
    }
    await loadMore(reset: true);
  }
}
