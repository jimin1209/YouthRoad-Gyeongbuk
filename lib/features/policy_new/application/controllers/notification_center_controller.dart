import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../providers.dart';
import '../services/policy_reminder_service.dart';

class NotificationCenterState {
  const NotificationCenterState({
    required this.upcoming,
    required this.past,
    this.isRefreshing = false,
    this.isMutating = false,
  });

  final List<PolicyReminder> upcoming;
  final List<PolicyReminder> past;
  final bool isRefreshing;
  final bool isMutating;

  NotificationCenterState copyWith({
    List<PolicyReminder>? upcoming,
    List<PolicyReminder>? past,
    bool? isRefreshing,
    bool? isMutating,
  }) {
    return NotificationCenterState(
      upcoming: upcoming ?? this.upcoming,
      past: past ?? this.past,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isMutating: isMutating ?? this.isMutating,
    );
  }

  static NotificationCenterState initial() => const NotificationCenterState(
        upcoming: [],
        past: [],
        isRefreshing: true,
      );
}

class NotificationCenterController
    extends StateNotifier<AsyncValue<NotificationCenterState>> {
  NotificationCenterController({required this.ref})
      : super(const AsyncData(NotificationCenterState(upcoming: [], past: []))) {
    load();
  }

  final Ref ref;

  PolicyReminderService get _service => ref.read(policyReminderServiceProvider);

  Future<void> load() async {
    final previous = state.value ?? NotificationCenterState.initial();
    state = AsyncData(previous.copyWith(isRefreshing: true));
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
        previous.copyWith(
          upcoming: upcoming,
          past: past,
          isRefreshing: false,
          isMutating: false,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> cancelReminder(String reminderId) async {
    final previous = state.value ?? NotificationCenterState.initial();
    final updatedUpcoming = [
      for (final reminder in previous.upcoming)
        if (reminder.reminderId != reminderId) reminder,
    ];
    final updatedPast = [
      for (final reminder in previous.past)
        if (reminder.reminderId != reminderId) reminder,
    ];

    state = AsyncData(
      previous.copyWith(
        upcoming: updatedUpcoming,
        past: updatedPast,
        isMutating: true,
      ),
    );

    try {
      await _service.cancelReminder(reminderId);
      state = AsyncData(
        previous.copyWith(
          upcoming: updatedUpcoming,
          past: updatedPast,
          isMutating: false,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
