import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/di.dart';
import '../../../application/notifiers/policy_paging_notifier.dart'; // ← ★ 반드시 필요!!

import '../../../data/repositories/hybrid_policy_repository.dart';

final policyPrefetchProvider =
    AsyncNotifierProvider<PolicyPrefetchNotifier, void>(
  PolicyPrefetchNotifier.new,
);

class PolicyPrefetchNotifier extends AsyncNotifier<void> {
  HybridPolicyRepository get _repository =>
      ref.read(hybridPolicyRepositoryProvider);

  PolicyPagingNotifier get _pagingNotifier =>
      ref.read(policyPagingProvider.notifier); // ← 오류 해결됨!

  @override
  Future<void> build() async {}

  Future<void> start() async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();

    try {
      final cached = await _repository.loadCachedPolicies(
        filter: _pagingNotifier.currentFilter,
      );
      if (cached.isNotEmpty) {
        _pagingNotifier.seedFromCache(cached);
      }
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] cache preload failed: $e\n$st');
    }

    try {
      final remote = await _repository.fetchPolicies(
        filter: _pagingNotifier.currentFilter,
      );
      _pagingNotifier.replaceWithFresh(remote);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] remote prefetch failed: $e\n$st');
      state = AsyncValue.error(e, st);
    }
  }
}
