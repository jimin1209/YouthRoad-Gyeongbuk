import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/policy.dart';
import '../data/user_engagement_storage.dart';

class PolicyEngagementState {
  final Map<String, int> clickCounts;
  final List<Policy> recentPolicies;

  const PolicyEngagementState({
    this.clickCounts = const {},
    this.recentPolicies = const [],
  });

  PolicyEngagementState copyWith({
    Map<String, int>? clickCounts,
    List<Policy>? recentPolicies,
  }) {
    return PolicyEngagementState(
      clickCounts: clickCounts ?? this.clickCounts,
      recentPolicies: recentPolicies ?? this.recentPolicies,
    );
  }

  Set<String> get recentPolicyIds => recentPolicies.map((policy) => policy.id).toSet();
}

final policyEngagementControllerProvider =
    AsyncNotifierProvider<PolicyEngagementController, PolicyEngagementState>(
  PolicyEngagementController.new,
);

class PolicyEngagementController extends AsyncNotifier<PolicyEngagementState> {
  late PolicyEngagementStorage _storage;

  @override
  Future<PolicyEngagementState> build() async {
    _storage = await PolicyEngagementStorage.create();
    return PolicyEngagementState(
      clickCounts: _storage.loadClickCounts(),
      recentPolicies: _storage.loadRecentPolicies(),
    );
  }

  Future<void> recordClick(Policy policy) async {
    final current = state.value ?? await future;
    final updated = Map<String, int>.from(current.clickCounts);
    updated.update(policy.id, (value) => value + 1, ifAbsent: () => 1);
    await _storage.saveClickCounts(updated);
    state = AsyncValue.data(current.copyWith(clickCounts: updated));
  }

  Future<void> recordView(Policy policy) async {
    final current = state.value ?? await future;
    final recent = List<Policy>.from(current.recentPolicies);
    recent.removeWhere((element) => element.id == policy.id);
    recent.insert(0, policy);
    if (recent.length > PolicyEngagementStorage.recentLimit) {
      recent.removeRange(PolicyEngagementStorage.recentLimit, recent.length);
    }
    await _storage.saveRecentPolicies(recent);
    state = AsyncValue.data(current.copyWith(recentPolicies: recent));
  }
}
