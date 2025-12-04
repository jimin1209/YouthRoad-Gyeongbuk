import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/policy_filter.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../di.dart';
import 'region_notifier.dart';

class PolicyListState {
  const PolicyListState({
    required this.policies,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.isStale,
    required this.error,
  });

  const PolicyListState.initial()
      : policies = const [],
        isLoading = true,
        isLoadingMore = false,
        hasMore = true,
        isStale = false,
        error = null;

  final List<Policy> policies;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final bool isStale;
  final Object? error;

  PolicyListState copyWith({
    List<Policy>? policies,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    bool? isStale,
    Object? error,
  }) {
    return PolicyListState(
      policies: policies ?? this.policies,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      isStale: isStale ?? this.isStale,
      error: error,
    );
  }
}

class PolicyListNotifier extends StateNotifier<PolicyListState> {
  PolicyListNotifier({
    required this.ref,
    required this.repository,
    this.pageSize = 20,
  })  : _page = 1,
        super(const PolicyListState.initial()) {
    _listenRegionChanges();
    _loadInitial();
  }

  static const errorMessage = '정책 정보를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';

  final Ref ref;
  final PolicyRepository repository;
  final int pageSize;

  int _page;
  bool _isFetching = false;

  void _listenRegionChanges() {
    ref.listen<String?>(regionProvider, (previous, next) {
      if (previous != next) {
        refresh();
      }
    });
  }

  PolicyFilter _buildFilter(int page) {
    final region = ref.read(regionProvider);
    return PolicyFilter(
      searchRgnSe: region,
      pageIndex: page,
      recordCount: pageSize,
      pageSize: pageSize,
      pagingYn: 'Y',
      searchDsplyYn: 'all',
      availableOnly: true,
    );
  }

  Future<void> _loadInitial() async {
    if (_isFetching) return;
    _isFetching = true;
    _page = 1;
    state = const PolicyListState.initial();

    try {
      final filter = _buildFilter(_page);
      final result = await repository.getPolicies(filter: filter);

      final cached = result.policies;
      state = state.copyWith(
        policies: List<Policy>.from(cached),
        isLoading: false,
        isLoadingMore: false,
        hasMore: cached.length >= pageSize,
        isStale: result.remoteRefresh != null,
        error: null,
      );

      final remote = result.remoteRefresh;
      if (remote != null) {
        final fresh = await remote;
        state = state.copyWith(
          policies: List<Policy>.from(fresh),
          isLoading: false,
          isLoadingMore: false,
          hasMore: fresh.length >= pageSize,
          isStale: false,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e,
        isStale: false,
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<void> refresh() async {
    await _loadInitial();
  }

  Future<void> loadNextPage() async {
    if (_isFetching || state.isLoadingMore || !state.hasMore) return;
    _isFetching = true;
    final nextPage = _page + 1;
    state = state.copyWith(isLoadingMore: true, error: null);

    try {
      final filter = _buildFilter(nextPage);
      final items = await repository.refreshPolicies(filter: filter);
      state = state.copyWith(
        policies: [...state.policies, ...items],
        isLoadingMore: false,
        hasMore: items.length >= pageSize,
        isStale: false,
        error: null,
      );
      _page = nextPage;
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e,
      );
    } finally {
      _isFetching = false;
    }
  }
}

final policyListNotifierProvider =
    StateNotifierProvider<PolicyListNotifier, PolicyListState>((ref) {
  final repository = ref.watch(policyRepositoryProvider);
  return PolicyListNotifier(
    ref: ref,
    repository: repository,
  );
});
