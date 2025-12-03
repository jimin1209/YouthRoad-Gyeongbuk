import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../domain/values/reminder_time_kind.dart';
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

  Future<void> setReminders(Policy policy, List<ReminderTimeKind> kinds) async {
    final previous = [...(state.value ?? [])];
    state = const AsyncLoading();
    try {
      final currentKinds = previous.map((reminder) => reminder.timeKind).toSet();
      final nextKinds = kinds.toSet();

      final toAdd = nextKinds.difference(currentKinds).toList();
      final toRemove = currentKinds.difference(nextKinds);

      final removed = <PolicyReminder>[];
      for (final reminder in previous) {
        if (toRemove.contains(reminder.timeKind)) {
          await _service.cancelReminder(reminder.reminderId);
          removed.add(reminder);
        }
      }

      final added = await _service.createRemindersForPolicy(policy, toAdd);

      final current = [
        for (final reminder in previous)
          if (!removed.contains(reminder)) reminder,
        ...added,
      ]
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

      state = AsyncData(current);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> removeReminder(String reminderId) async {
    final previous = [...(state.value ?? [])];
    state = const AsyncLoading();
    try {
      await _service.cancelReminder(reminderId);
      final current = [
        for (final reminder in previous)
          if (reminder.reminderId != reminderId) reminder,
      ]
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      state = AsyncData(current);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> cancelAll() async {
    state = const AsyncLoading();
    try {
      await _service.cancelAllByPolicy(policyId);
      state = const AsyncData([]);
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
