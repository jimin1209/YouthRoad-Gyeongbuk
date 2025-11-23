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
  static const String errorMessage = '정책을 불러오지 못했습니다. 다시 시도해 주세요.';

  @override
  PolicyPagingState build() {
    _repo = ref.read(policyRepositoryProvider);
    ref.listen<String?>(regionProvider, (_, __) => _loadInitial());
    _loadInitial();
    return const PolicyPagingState(
      items: [],
      page: 1,
      isLoading: false,
      hasMore: true,
      initialLoaded: false,
    );
  }

  Future<void> _loadInitial() async {
    await loadMore(reset: true);
  }

  Future<void> loadMore({bool reset = false}) async {
    if (state.isLoading) return;
    final nextPage = reset ? 1 : state.page + 1;
    final selectedRegion = ref.read(regionProvider);
    state = state.copyWith(
      items: reset ? [] : state.items,
      page: nextPage,
      isLoading: true,
      error: null,
      hasMore: reset ? true : state.hasMore,
    );
    try {
      final List<Policy> newItems = await _repo.fetchPolicies(
        filter: PolicyFilter(
          searchRgnSe: selectedRegion,
          pageIndex: nextPage,
          recordCount: 10,
        ),
      );
      final merged = <Policy>[...(reset ? <Policy>[] : state.items), ...newItems];
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
      state = state.copyWith(
        items: state.items,
        page: state.page,
        isLoading: false,
        hasMore: false,
        error: errorMessage,
        initialLoaded: true,
      );
    }
  }
}
