import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/di.dart';
import '../../../data/repositories/policy_repository.dart';
import '../../policy/providers/policy_list_provider.dart';

final policyPrefetchProvider =
    AutoDisposeAsyncNotifierProvider<PolicyPrefetchNotifier, void>(
  PolicyPrefetchNotifier.new,
);

class PolicyPrefetchNotifier extends AutoDisposeAsyncNotifier<void> {
  HybridPolicyRepository get _repo =>
      ref.read(hybridPolicyRepositoryProvider);
  PolicyListNotifier get _list => ref.read(policyListProvider.notifier);

  @override
  Future<void> build() async {
    return prefetchPolicies();
  }

  Future<void> prefetchPolicies() async {
    try {
      final cached = await _repo.loadFromCache();
      if (cached.isNotEmpty) {
        _list.setPolicies(cached);
      }
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] cache load failed: $e');
      debugPrint('$st');
    }

    try {
      final models = await _repo.fetchAllFromApi();
      await _repo.saveToCache(models);
      final domainPolicies = models.map((m) => m.toEntity()).toList();
      _list.setPolicies(domainPolicies);
    } catch (e, st) {
      debugPrint('[PolicyPrefetchNotifier] api fetch failed: $e');
      debugPrint('$st');
    }
  }
}
