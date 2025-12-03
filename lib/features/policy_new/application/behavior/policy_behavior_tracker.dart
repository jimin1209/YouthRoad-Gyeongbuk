import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/policy_event.dart';
import '../controllers/policy_event_bus.dart';

class PolicyBehaviorState {
  final Map<String, int> policyScores;
  final Map<String, int> tagScores;

  const PolicyBehaviorState({
    this.policyScores = const {},
    this.tagScores = const {},
  });

  PolicyBehaviorState copyWith({
    Map<String, int>? policyScores,
    Map<String, int>? tagScores,
  }) {
    return PolicyBehaviorState(
      policyScores: policyScores ?? this.policyScores,
      tagScores: tagScores ?? this.tagScores,
    );
  }

  List<String> topTags({int limit = 5}) {
    final sorted = tagScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).map((e) => e.key).toList();
  }
}

class PolicyBehaviorTracker extends StateNotifier<PolicyBehaviorState> {
  PolicyBehaviorTracker(this.ref) : super(const PolicyBehaviorState());

  final Ref ref;

  void recordDetailView(Policy policy) {
    _applyScores(
      policyScoreDelta: {policy.id: 4},
      tagScoreDelta: {for (final tag in policy.tags) tag: 2},
    );
  }

  void recordFavoriteChanged(Policy policy, {required bool added}) {
    final delta = added ? 10 : -6;
    _applyScores(
      policyScoreDelta: {policy.id: delta},
      tagScoreDelta: {for (final tag in policy.tags) tag: delta ~/ 2},
    );
  }

  void recordCompareChanged(Policy policy, {required bool added}) {
    final delta = added ? 6 : -4;
    _applyScores(
      policyScoreDelta: {policy.id: delta},
      tagScoreDelta: {for (final tag in policy.tags) tag: delta ~/ 2},
    );
  }

  void reset() {
    state = const PolicyBehaviorState();
    _notifyBehaviorChanged();
  }

  void _applyScores({
    Map<String, int>? policyScoreDelta,
    Map<String, int>? tagScoreDelta,
  }) {
    final nextPolicyScores = Map<String, int>.from(state.policyScores);
    final nextTagScores = Map<String, int>.from(state.tagScores);

    policyScoreDelta?.forEach((key, delta) {
      nextPolicyScores.update(key, (value) => value + delta, ifAbsent: () => delta);
      if (nextPolicyScores[key] != null && nextPolicyScores[key]! <= 0) {
        nextPolicyScores.remove(key);
      }
    });

    tagScoreDelta?.forEach((key, delta) {
      nextTagScores.update(key, (value) => value + delta, ifAbsent: () => delta);
      if (nextTagScores[key] != null && nextTagScores[key]! <= 0) {
        nextTagScores.remove(key);
      }
    });

    state = state.copyWith(
      policyScores: nextPolicyScores,
      tagScores: nextTagScores,
    );

    _notifyBehaviorChanged();
  }

  void _notifyBehaviorChanged() {
    ref
        .read(policyEventBusProvider.notifier)
        .emit(const PolicyEvent(PolicyEventType.behaviorChanged));
  }
}

final policyBehaviorTrackerProvider =
    StateNotifierProvider<PolicyBehaviorTracker, PolicyBehaviorState>(
  (ref) => PolicyBehaviorTracker(ref),
);
