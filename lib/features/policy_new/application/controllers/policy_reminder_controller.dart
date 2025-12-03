import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../providers.dart';
import '../services/policy_reminder_service.dart';

class PolicyReminderController
    extends StateNotifier<AsyncValue<PolicyReminder?>> {
  PolicyReminderController({
    required this.ref,
    required this.policyId,
  }) : super(const AsyncLoading()) {
    initialize();
  }

  final Ref ref;
  final String policyId;

  PolicyReminderService get _service => ref.read(policyReminderServiceProvider);

  Future<void> initialize() async {
    await _service.cleanupExpiredReminders();
    await load();
  }

  Future<void> load() async {
    state = const AsyncLoading();
    final reminders =
        await ref.read(policyReminderRepositoryProvider).getRemindersForPolicy(
              policyId,
            );
    final existing = reminders.isEmpty ? null : reminders.first;
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
      await _service.cancelReminderByPolicyId(policyId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  PolicyReminderStatus? currentStatus() {
    return state.maybeWhen(data: (reminder) => reminder?.status, orElse: () => null);
  }
}
