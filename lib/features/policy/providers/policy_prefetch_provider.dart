import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/notifiers/policy_paging_notifier.dart'; // ← ★ 반드시 필요!!
import '../../../application/providers.dart';
import '../../../domain/repositories/policy_repository.dart';
import 'policy_list_provider.dart';

final policyPrefetchProvider =
    AsyncNotifierProvider<PolicyPrefetchNotifier, void>(
  PolicyPrefetchNotifier.new,
);

class PolicyPrefetchNotifier extends AsyncNotifier<void> {
  PolicyRepository get _repository =>
      ref.read(policyRepositoryInterfaceProvider);

  PolicyPagingNotifier get _pagingNotifier =>
      ref.read(policyPagingProvider.notifier); // ← 오류 해결됨!

  PolicyListNotifier get _listNotifier => ref.read(policyListProvider.notifier);

  @override
  Future<void> build() async {}

  Future<void> prefetchPolicies() async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    _listNotifier.setLoading();

    try {
      final cached = await _repository.loadCachedPolicies(
        filter: _pagingNotifier.currentFilter,
      );
      if (cached.isNotEmpty) {
        _pagingNotifier.seedFromCache(cached);
        _listNotifier.setPolicies(cached);
      } else {
        _listNotifier.clear();
      }
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] cache preload failed: $e\n$st');
      _listNotifier.setError(e, st);
    }

    try {
      final remote = await _repository.refreshPolicies(
        filter: _pagingNotifier.currentFilter,
      );
      _pagingNotifier.replaceWithFresh(remote);
      _listNotifier.setPolicies(remote);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] remote prefetch failed: $e\n$st');
      _listNotifier.setError(e, st);
      state = AsyncValue.error(e, st);
    }
  }
}
