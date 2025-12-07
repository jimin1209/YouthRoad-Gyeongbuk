import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_region.dart';

class PolicyBehaviorRecord {
  final String policyId;
  final PolicyRegion region;
  final PolicyCategory category;
  final List<String> tags;
  final DateTime timestamp;

  const PolicyBehaviorRecord({
    required this.policyId,
    required this.region,
    required this.category,
    required this.tags,
    required this.timestamp,
  });
}

class PolicyBehaviorState {
  final List<PolicyBehaviorRecord> recentViewedPolicies;
  final List<PolicyBehaviorRecord> recentFavorites;

  const PolicyBehaviorState({
    this.recentViewedPolicies = const [],
    this.recentFavorites = const [],
  });

  PolicyBehaviorState copyWith({
    List<PolicyBehaviorRecord>? recentViewedPolicies,
    List<PolicyBehaviorRecord>? recentFavorites,
  }) {
    return PolicyBehaviorState(
      recentViewedPolicies: recentViewedPolicies ?? this.recentViewedPolicies,
      recentFavorites: recentFavorites ?? this.recentFavorites,
    );
  }
}

class PolicyBehaviorController extends StateNotifier<PolicyBehaviorState> {
  PolicyBehaviorController() : super(const PolicyBehaviorState());

  static const _maxKeep = 30;

  void recordView(Policy policy) {
    _record(
      policy: policy,
      asFavorite: false,
    );
  }

  void recordFavorite(Policy policy) {
    _record(
      policy: policy,
      asFavorite: true,
    );
  }

  void syncFavorites(List<Policy> policies, List<String> favoriteIds) {
    for (final policy in policies) {
      if (favoriteIds.contains(policy.id)) {
        _record(policy: policy, asFavorite: true);
      }
    }
  }

  void _record({required Policy policy, required bool asFavorite}) {
    final record = PolicyBehaviorRecord(
      policyId: policy.id,
      region: policy.region,
      category: policy.category,
      tags: policy.tags,
      timestamp: DateTime.now(),
    );

    if (asFavorite) {
      _updateList(isFavorite: true, record: record);
    } else {
      _updateList(isFavorite: false, record: record);
    }
  }

  void _updateList({required bool isFavorite, required PolicyBehaviorRecord record}) {
    final current = isFavorite
        ? List<PolicyBehaviorRecord>.from(state.recentFavorites)
        : List<PolicyBehaviorRecord>.from(state.recentViewedPolicies);

    current.removeWhere((element) => element.policyId == record.policyId);
    current.insert(0, record);

    if (current.length > _maxKeep) {
      current.removeRange(_maxKeep, current.length);
    }

    if (isFavorite) {
      state = state.copyWith(recentFavorites: current);
    } else {
      state = state.copyWith(recentViewedPolicies: current);
    }
  }
}
