import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/reminder_repository.dart';

class NotificationCenterState {
  const NotificationCenterState({
    this.upcomingReminders = const [],
    this.pastReminders = const [],
    this.isLoading = false,
  });

  final List<PolicyReminder> upcomingReminders;
  final List<PolicyReminder> pastReminders;
  final bool isLoading;

  NotificationCenterState copyWith({
    List<PolicyReminder>? upcomingReminders,
    List<PolicyReminder>? pastReminders,
    bool? isLoading,
  }) {
    return NotificationCenterState(
      upcomingReminders: upcomingReminders ?? this.upcomingReminders,
      pastReminders: pastReminders ?? this.pastReminders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class NotificationCenterController
    extends StateNotifier<NotificationCenterState> {
  NotificationCenterController({required this.repository})
      : super(const NotificationCenterState());

  final ReminderRepository repository;

  Future<void> loadReminders() async {
    state = state.copyWith(isLoading: true);
    final reminders = await repository.getAllReminders();
    final now = DateTime.now();

    final upcoming = <PolicyReminder>[];
    final past = <PolicyReminder>[];

    for (final reminder in reminders) {
      if (reminder.scheduledAt.isAfter(now)) {
        upcoming.add(reminder);
      } else {
        past.add(reminder.copyWith(status: PolicyReminderStatus.expired));
      }
    }

    state = state.copyWith(
      upcomingReminders: List.unmodifiable(upcoming),
      pastReminders: List.unmodifiable(past),
      isLoading: false,
    );
  }
}
