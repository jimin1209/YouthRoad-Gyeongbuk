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
    final current = state.asData?.value ?? [];
    state = AsyncValue.data(List.unmodifiable([...current, policy]));
  }

  void update(Policy policy) {
    final current = state.asData?.value ?? [];
    final updated = current.map((item) => item.id == policy.id ? policy : item).toList();
    state = AsyncValue.data(List.unmodifiable(updated));
  }

  void remove(String id) {
    final current = state.asData?.value ?? [];
    final updated = current.where((item) => item.id != id).toList();
    state = AsyncValue.data(List.unmodifiable(updated));
  }

  void setError(Object error, [StackTrace? stackTrace]) {
    state = AsyncValue.error(error, stackTrace ?? StackTrace.current);
  }
}
