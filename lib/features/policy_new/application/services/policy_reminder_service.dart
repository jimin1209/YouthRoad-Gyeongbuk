import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';
import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../domain/values/reminder_time_kind.dart';
import '../../domain/utils/reminder_id_util.dart';
import '../../domain/values/policy_logger.dart';
import '../../domain/values/schedule_result.dart';
import '../controllers/policy_event_bus.dart';
import '../gateways/notification_gateway.dart';
import 'policy_reminder_scheduler.dart';

class ReminderMutationFailure {
  const ReminderMutationFailure({
    required this.timeKind,
    required this.failure,
  });

  final ReminderTimeKind timeKind;
  final ScheduleFailure failure;
}

class ReminderMutationResult {
  const ReminderMutationResult({
    required this.reminders,
    required this.failures,
  });

  final List<PolicyReminder> reminders;
  final List<ReminderMutationFailure> failures;

  bool get hasFailure => failures.isNotEmpty;
}

class PolicyReminderService {
  PolicyReminderService({
    required this.repository,
    required this.notificationGateway,
    required this.eventBus,
    required this.scheduler,
    required this.logger,
  });

  final PolicyReminderRepository repository;
  final NotificationGateway notificationGateway;
  final PolicyEventBus eventBus;
  final PolicyReminderScheduler scheduler;
  final PolicyLogger logger;

  Future<ReminderMutationResult> createRemindersForPolicy(
    Policy policy,
    List<ReminderTimeKind> kinds,
  ) async {
    final now = DateTime.now().toUtc();
    final reminders = <PolicyReminder>[];
    final failures = <ReminderMutationFailure>[];

    for (final kind in kinds) {
      final schedule = scheduler.buildSchedule(policy, option: kind);
      if (schedule.status == PolicyReminderStatus.expired) {
        failures.add(
          ReminderMutationFailure(
            timeKind: kind,
            failure: const ScheduleFailure(
              type: ScheduleFailureType.invalidDate,
              message: 'Scheduled time already passed',
            ),
          ),
        );
        logger.warn('Reminder for ${policy.id} skipped: already past.');
        continue;
      }

      final reminderId = ReminderIdUtil.buildReminderId(policy.id, kind);
      final existing = await repository.getReminder(reminderId);

      final reminder = PolicyReminder(
        reminderId: reminderId,
        policyId: policy.id,
        scheduledAt: schedule.scheduledAt,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
        timeKind: kind,
        status: schedule.status,
        policyTitleSnapshot: policy.title,
      );

      final scheduleResult = await notificationGateway.scheduleReminder(reminder);
      if (!scheduleResult.success) {
        final failure = scheduleResult.failure ??
            const ScheduleFailure(
              type: ScheduleFailureType.unknown,
              message: 'Unknown scheduling failure',
            );
        failures.add(
          ReminderMutationFailure(
            timeKind: kind,
            failure: failure,
          ),
        );
        logger.warn('Notification scheduling failed for ${reminder.reminderId}');
        continue;
      }

      reminders.add(reminder);
      await repository.upsertReminder(reminder);
    }

    if (reminders.isNotEmpty) {
      eventBus.emit(PolicyEvent(
        PolicyEventType.reminderChanged,
        policyId: policy.id,
      ));
    }

    return ReminderMutationResult(reminders: reminders, failures: failures);
  }

  Future<void> cancelReminder(String reminderId) async {
    final reminder = await repository.getReminder(reminderId);
    if (reminder == null) return;

    await repository.deleteReminderById(reminder.reminderId);
    final result = await notificationGateway.cancelReminder(reminder.reminderId);
    if (!result.success) {
      logger.warn(
        'Failed to cancel reminder $reminderId: ${result.failure?.message}',
      );
    }
    eventBus.emit(PolicyEvent(
      PolicyEventType.reminderChanged,
      policyId: reminder.policyId,
    ));
  }

  Future<void> cancelAllByPolicy(String policyId) async {
    final reminders = await repository.getRemindersForPolicy(policyId);
    final bulkResult = await notificationGateway.cancelAllForPolicy(policyId);
    if (!bulkResult.success) {
      logger.warn(
        'Failed to cancel all reminders for $policyId: ${bulkResult.failure?.message}',
      );
    }
    for (final reminder in reminders) {
      final result = await notificationGateway.cancelReminder(reminder.reminderId);
      if (!result.success) {
        logger.warn(
          'Failed to cancel reminder ${reminder.reminderId}: ${result.failure?.message}',
        );
      }
    }
    await repository.deleteRemindersByPolicy(policyId);
    if (reminders.isNotEmpty) {
      eventBus.emit(PolicyEvent(
        PolicyEventType.reminderChanged,
        policyId: policyId,
      ));
    }
  }

  Future<List<PolicyReminder>> cleanupExpiredReminders() async {
    final all = await repository.getAllReminders();
    final now = DateTime.now().toUtc();
    final updated = <PolicyReminder>[];

    for (final reminder in all) {
      if (reminder.status == PolicyReminderStatus.scheduled &&
          reminder.scheduledAt.isBefore(now)) {
        final expiredReminder = reminder.copyWith(
          status: PolicyReminderStatus.expired,
          updatedAt: now,
        );
        await repository.upsertReminder(expiredReminder);
        await notificationGateway.cancelReminder(expiredReminder.reminderId);
        updated.add(expiredReminder);
      }
    }

    if (updated.isNotEmpty) {
      eventBus.emit(const PolicyEvent(PolicyEventType.reminderBulkUpdated));
    }
    return updated;
  }
}
