import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../providers.dart';
import '../services/policy_reminder_service.dart';

class PolicyReminderController
    extends StateNotifier<AsyncValue<PolicyReminder?>> {
  PolicyReminderController({
    required this.ref,
    required this.policyId,
  }) : super(const AsyncLoading()) {
    load();
  }

  final Ref ref;
  final String policyId;

  PolicyReminderService get _service => ref.read(policyReminderServiceProvider);

  Future<void> load() async {
    state = const AsyncLoading();
    final existing =
        await ref.read(policyReminderRepositoryProvider).getByPolicyId(policyId);
    state = AsyncData(existing);
  }

  Future<void> setReminder(Policy policy, PolicyReminderOption option) async {
    state = const AsyncLoading();
    try {
      final reminder = await _service.upsertReminder(policy, option: option);
      state = AsyncData(reminder);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> cancelReminder() async {
    state = const AsyncLoading();
    try {
      await _service.cancelReminder(policyId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
