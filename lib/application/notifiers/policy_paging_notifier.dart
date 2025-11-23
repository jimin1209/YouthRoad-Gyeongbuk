import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../di.dart';

class PolicyPagingState {
  const PolicyPagingState({
    required this.items,
    required this.page,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  final List<Policy> items;
  final int page;
  final bool isLoading;
  final bool hasMore;
  final String? error;
}

class PolicyPagingNotifier extends AutoDisposeNotifier<PolicyPagingState> {
  late final PolicyRepository _repo;

  @override
  PolicyPagingState build() {
    _repo = ref.read(policyRepositoryProvider);
    _loadInitial();
    return const PolicyPagingState(items: [], page: 1, isLoading: false);
  }

  Future<void> _loadInitial() async {
    await loadMore(reset: true);
  }

  Future<void> loadMore({bool reset = false}) async {
    if (state.isLoading) return;
    final nextPage = reset ? 1 : state.page + 1;
    state = PolicyPagingState(
      items: reset ? [] : state.items,
      page: nextPage,
      isLoading: true,
      hasMore: state.hasMore,
    );
    try {
      final List<Policy> newItems = await _repo.fetchPolicies(page: nextPage);
      final merged = <Policy>[...(reset ? <Policy>[] : state.items), ...newItems];
      state = PolicyPagingState(
        items: merged,
        page: nextPage,
        isLoading: false,
        hasMore: newItems.isNotEmpty,
      );
    } catch (e) {
      state = PolicyPagingState(
        items: state.items,
        page: state.page,
        isLoading: false,
        hasMore: false,
        error: '$e',
      );
    }
  }
}
