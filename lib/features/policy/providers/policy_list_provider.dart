import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/policy.dart';

final policyListProvider =
    StateNotifierProvider<PolicyListNotifier, AsyncValue<List<Policy>>>(
  (ref) => PolicyListNotifier(),
);

class PolicyListNotifier extends StateNotifier<AsyncValue<List<Policy>>> {
  PolicyListNotifier() : super(const AsyncValue.loading());

  void setPolicies(List<Policy> policies) {
    state = AsyncValue.data(List.unmodifiable(policies));
  }

  void clear() {
    state = const AsyncValue.data([]);
  }

  void setLoading() {
    state = const AsyncValue.loading();
  }

  void add(Policy policy) {
    state = state.whenData((value) {
      final updated = [...value, policy];
      return List.unmodifiable(updated);
    });
  }

  void update(Policy policy) {
    state = state.whenData((value) {
      final updated = value.map((item) {
        if (item.id == policy.id) {
          return policy;
        }
        return item;
      }).toList();
      return List.unmodifiable(updated);
    });
  }

  void remove(String id) {
    state = state.whenData((value) {
      final updated = value.where((item) => item.id != id).toList();
      return List.unmodifiable(updated);
    });
  }
}
