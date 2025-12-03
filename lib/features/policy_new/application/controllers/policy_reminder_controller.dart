import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../providers.dart';
import '../services/policy_reminder_service.dart';

class PolicyReminderController
    extends StateNotifier<AsyncValue<List<PolicyReminder>>> {
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
    reminders.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    state = AsyncData(reminders);
  }

  Future<void> setReminder(Policy policy, PolicyReminderOption option) async {
    final previous = [...(state.value ?? [])];
    state = const AsyncLoading();
    try {
      final reminder = await _service.upsertReminder(policy, option: option);
      final current = [...previous];
      current.removeWhere((item) => item.timeKind == option);
      current.add(reminder);
      current.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      state = AsyncData(current);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> cancelReminder(PolicyReminderOption option) async {
    final previous = [...(state.value ?? [])];
    state = const AsyncLoading();
    try {
      await _service.cancelReminderByPolicyAndTimeKind(policyId, option);
      final current = [...previous]..removeWhere((item) => item.timeKind == option);
      current.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      state = AsyncData(current);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  PolicyReminderStatus? currentStatus() {
    return state.maybeWhen(
      data: (reminders) {
        if (reminders.isEmpty) return null;
        final sorted = [...reminders]
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        return sorted.first.status;
      },
      orElse: () => null,
    );
  }
}
