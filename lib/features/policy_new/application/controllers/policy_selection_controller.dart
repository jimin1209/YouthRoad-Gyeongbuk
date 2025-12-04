import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/policy_event.dart';
import '../behavior/policy_behavior_tracker.dart';
import '../models/user_collections.dart';
import '../providers.dart';
import 'policy_event_bus.dart';
import '../../data/sources/compare_local_data_source.dart';

class CompareController extends StateNotifier<CompareRepository> {
  CompareController(this.ref) : super(const CompareRepository()) {
    _load();
  }

  final Ref ref;

  CompareLocalDataSource get _localSource =>
      ref.read(compareLocalDataSourceProvider);

  bool isCompared(String policyId) => state.ids.contains(policyId);

  Future<void> _load() async {
    final stored = _localSource.loadIds();
    if (stored.isNotEmpty) {
      state = CompareRepository(ids: stored);
    }
  }

  Future<void> toggleCompare(Policy policy) async {
    final exists = state.ids.contains(policy.id);
    if (!exists && state.ids.length >= 4) {
      return;
    }

    final updated = [
      for (final id in state.ids)
        if (id != policy.id) id,
    ];

    if (!exists) {
      updated.add(policy.id);
    }

    await _persistAndNotify(updated, policy: policy, added: !exists);
  }

  Future<void> remove(String policyId) async {
    if (!state.ids.contains(policyId)) return;

    final updated = [
      for (final id in state.ids)
        if (id != policyId) id,
    ];

    await _persistAndNotify(updated, policyId: policyId, added: false);
  }

  Future<void> clear() async {
    await _persistAndNotify(const [], added: false);
  }

  Future<void> _persistAndNotify(
    List<String> ids, {
    Policy? policy,
    String? policyId,
    required bool added,
  }) async {
    state = CompareRepository(ids: ids);
    await _localSource.saveIds(ids);

    final targetPolicyId = policy?.id ?? policyId;
    if (targetPolicyId != null) {
      ref.read(policyEventBusProvider.notifier).emit(
            PolicyEvent(PolicyEventType.compareListChanged,
                policyId: targetPolicyId),
          );
    }

    if (policy != null) {
      ref
          .read(policyBehaviorTrackerProvider.notifier)
          .recordCompareChanged(policy, added: added);
    }
  }
}
