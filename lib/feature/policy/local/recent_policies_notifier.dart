import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/policy_models.dart';
import 'local_policy_store.dart';

class RecentPoliciesNotifier extends StateNotifier<AsyncValue<List<PolicyItem>>> {
  RecentPoliciesNotifier(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final Ref _ref;

  Future<void> load() async {
    try {
      final store = _ref.read(localPolicyStoreProvider);
      final items = await store.loadRecent();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addRecent(PolicyItem item) async {
    final store = _ref.read(localPolicyStoreProvider);
    await store.addRecent(item);
    await load();
  }

  Future<void> clear() async {
    final store = _ref.read(localPolicyStoreProvider);
    await store.clearAll();
    await load();
  }
}

final recentPoliciesProvider =
    StateNotifierProvider<RecentPoliciesNotifier, AsyncValue<List<PolicyItem>>>(
  (ref) => RecentPoliciesNotifier(ref),
);
