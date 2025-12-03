import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../providers.dart';
import '../services/policy_reminder_service.dart';

class NotificationCenterState {
  const NotificationCenterState({
    required this.upcoming,
    required this.past,
  });

  final List<PolicyReminder> upcoming;
  final List<PolicyReminder> past;
}

class NotificationCenterController
    extends StateNotifier<AsyncValue<NotificationCenterState>> {
  NotificationCenterController({required this.ref})
      : super(const AsyncLoading()) {
    load();
  }

  final Ref ref;

  PolicyReminderService get _service => ref.read(policyReminderServiceProvider);

  Future<void> load() async {
    state = const AsyncLoading();
    try {
      await _service.cleanupExpiredReminders();
      final reminders =
          await ref.read(policyReminderRepositoryProvider).getAllReminders();
      final now = DateTime.now().toUtc();
      final upcoming = <PolicyReminder>[];
      final past = <PolicyReminder>[];

      for (final reminder in reminders) {
        if (reminder.status == PolicyReminderStatus.scheduled &&
            reminder.scheduledAt.isAfter(now)) {
          upcoming.add(reminder);
        } else {
          past.add(reminder);
        }
      }

      upcoming.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      past.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

      state = AsyncData(
        NotificationCenterState(
          upcoming: upcoming,
          past: past,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> cancelReminder(String reminderId) async {
    state = const AsyncLoading();
    try {
      await _service.cancelReminderById(reminderId);
      await load();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
