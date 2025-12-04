import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../services/policy_reminder_service.dart';
import '../providers.dart';

class PolicyDetailController extends StateNotifier<AsyncValue<Policy>> {
  PolicyDetailController({
    required this.ref,
    required this.policyId,
  }) : super(const AsyncValue.loading()) {
    _load();
  }

  final Ref ref;
  final String policyId;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    final repo = ref.read(policyRepositoryProvider);
    final result = await repo.fetchPolicyDetail(policyId);

    if (result.data != null) {
      final policy = result.data!;
      state = AsyncValue.data(policy);
      try {
        await ref
            .read(policyReminderServiceProvider)
            .reconcileRemindersWithPolicy(policy);
      } catch (_) {}
      return;
    }

    state = AsyncValue.error(
      result.failure ?? Exception('Unknown policy detail failure'),
      StackTrace.current,
    );
  }

  Future<void> refresh() => _load();
}
