import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_policy_store.dart';

class FavoritePoliciesNotifier extends StateNotifier<AsyncValue<List<String>>> {
  FavoritePoliciesNotifier(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final Ref _ref;

  Future<void> load() async {
    try {
      final store = _ref.read(localPolicyStoreProvider);
      final favorites = await store.loadFavorites();
      state = AsyncValue.data(favorites);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggle(String policyId) async {
    final store = _ref.read(localPolicyStoreProvider);
    await store.toggleFavorite(policyId);
    await load();
  }
}

final favoritePoliciesProvider =
    StateNotifierProvider<FavoritePoliciesNotifier, AsyncValue<List<String>>>(
  (ref) => FavoritePoliciesNotifier(ref),
);
