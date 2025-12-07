import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_failure.dart';
import '../../domain/values/policy_query.dart';
import '../providers.dart';
import 'policy_paging_state.dart';
import 'policy_query_engine.dart';

abstract class BasePolicyFeedController extends StateNotifier<PolicyPagingState> {
  BasePolicyFeedController({
    required this.ref,
    required this.queryEngine,
  }) : super(const PolicyPagingState.initial()) {
    ref.listen<PolicyQuery>(
      policyQueryProvider(feedType),
      (previous, next) {
        if (previous == null || previous == next) return;
        refresh();
      },
    );
  }

  final Ref ref;
  final PolicyQueryEngine queryEngine;

  bool _hasRequestedInitial = false;
  int _page = 1;
  bool _isLoadingPage = false;

  PolicyFeedType get feedType;
  PolicyQuery buildBaseQuery();

  void ensureInitialized() {
    if (_hasRequestedInitial) return;
    _hasRequestedInitial = true;
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    _page = 1;
    _isLoadingPage = false;

    final query = buildBaseQuery();
    ref.read(policyScoreProvider.notifier).reset();
    state = const PolicyPagingState.loading();

    final result = await queryEngine.fetch(query, page: _page);
    if (result.isSuccess && result.data != null) {
      final scored =
          ref.read(policyScoreProvider.notifier).applyScore(result.data!, query: query);
      state = PolicyPagingState.data(
        items: scored,
        hasMore: result.data!.length == queryEngine.pageSize,
      );
    } else {
      state = PolicyPagingState.error(result.failure!);
    }
  }

  Future<void> loadNextPage() async {
    if (_isLoadingPage) return;
    if (!state.hasMore) return;

    _isLoadingPage = true;
    final nextPage = _page + 1;
    final query = buildBaseQuery();

    final result = await queryEngine.fetch(query, page: nextPage);
    if (result.isSuccess && result.data != null) {
      final merged = [...state.items, ...result.data!];
      final scored =
          ref.read(policyScoreProvider.notifier).applyScore(merged, query: query);
      state = PolicyPagingState.data(
        items: scored,
        hasMore: result.data!.length == queryEngine.pageSize,
      );
      _page = nextPage;
    } else {
      state = PolicyPagingState.error(result.failure!);
    }

    _isLoadingPage = false;
  }

  Future<void> refresh() async {
    await loadFirstPage();
  }
}
