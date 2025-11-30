import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/di.dart';
import '../../policy/providers/policy_list_provider.dart';

final policyPrefetchProvider =
    AutoDisposeAsyncNotifierProvider<PolicyPrefetchNotifier, void>(
  PolicyPrefetchNotifier.new,
);

class PolicyPrefetchNotifier extends AutoDisposeAsyncNotifier<void> {
  HybridPolicyRepository get _repo => ref.read(hybridPolicyRepositoryProvider);
  PolicyListNotifier get _list => ref.read(policyListProvider.notifier);

  @override
  Future<void> build() async {
    Future.microtask(prefetchPolicies);
  }

  Future<void> prefetchPolicies() async {
    state = const AsyncValue.loading();

    try {
      final cached = await _repo.loadFromCache();
      if (cached.isNotEmpty) {
        _list.setPolicies(cached);
      } else {
        _list.clear();
      }
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] cache load failed: $e\n$st');
    }

    try {
      final models = await _repo.fetchAllFromApi();
      await _repo.saveToCache(models);
      final policies = models.map((model) => model.toEntity()).toList();
      _list.setPolicies(policies);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] api fetch failed: $e\n$st');
      state = AsyncValue.error(e, st);
    }
  }
}
