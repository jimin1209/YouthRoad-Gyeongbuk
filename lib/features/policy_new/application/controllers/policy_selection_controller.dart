import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/policy_event.dart';
import '../behavior/policy_behavior_tracker.dart';
import '../models/user_collections.dart';
import 'policy_event_bus.dart';

class CompareController extends StateNotifier<CompareRepository> {
  CompareController(this.ref) : super(const CompareRepository());

  final Ref ref;

  bool isCompared(String policyId) => state.ids.contains(policyId);

  void toggleCompare(Policy policy) {
    final exists = state.ids.contains(policy.id);
    final updated = [
      for (final id in state.ids)
        if (id != policy.id) id,
    ];

    if (!exists) {
      updated.add(policy.id);
    }

    state = CompareRepository(ids: updated);

    ref.read(policyEventBusProvider.notifier).emit(
          PolicyEvent(PolicyEventType.compareListChanged, policyId: policy.id),
        );

    ref
        .read(policyBehaviorTrackerProvider.notifier)
        .recordCompareChanged(policy, added: !exists);
  }
}
