import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/values/policy_event.dart';
import '../providers.dart';

class NotificationCenterController
    extends StateNotifier<AsyncValue<List<PolicyReminder>>> {
  NotificationCenterController({
    required this.repository,
    required this.ref,
  }) : super(const AsyncValue.loading()) {
    _loadReminders();

    ref.listen<PolicyEvent?>(policyEventBusProvider, (previous, next) {
      if (next == null) return;
      if (next.type == PolicyEventType.reminderCreated ||
          next.type == PolicyEventType.reminderCanceled ||
          next.type == PolicyEventType.reminderFired) {
        _loadReminders();
      }
    });
  }

  final ReminderRepository repository;
  final Ref ref;

  Future<void> _loadReminders() async {
    state = const AsyncValue.loading();
    try {
      final reminders = await repository.listUpcoming();
      state = AsyncValue.data(reminders);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
