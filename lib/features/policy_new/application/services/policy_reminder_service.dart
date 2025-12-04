import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';
import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../domain/values/reminder_time_kind.dart';
import '../../domain/utils/reminder_id_util.dart';
import '../../domain/values/policy_logger.dart';
import '../../domain/values/schedule_result.dart';
import '../../domain/values/reminder_sync_report.dart';
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
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final PolicyReminderRepository repository;
  final NotificationGateway notificationGateway;
  final PolicyEventBus eventBus;
  final PolicyReminderScheduler scheduler;
  final PolicyLogger logger;
  final DateTime Function() _now;

  Future<bool> refreshEnvironment() async {
    final ready = await notificationGateway.refreshEnvironment();
    if (!ready) {
      logger.warn('Notification environment not ready (permission or timezone).');
    }
    return ready;
  }

  Future<ReminderMutationResult> createRemindersForPolicy(
    Policy policy,
    List<ReminderTimeKind> kinds,
  ) async {
    final now = _now().toUtc();
    final reminders = <PolicyReminder>[];
    final failures = <ReminderMutationFailure>[];
    final uniqueKinds = kinds.toSet();

    final environmentReady = await refreshEnvironment();
    if (!environmentReady) {
      for (final kind in uniqueKinds) {
        failures.add(
          ReminderMutationFailure(
            timeKind: kind,
            failure: const ScheduleFailure(
              type: ScheduleFailureType.permissionDenied,
              message: 'Notification environment not ready',
            ),
          ),
        );
      }
      return ReminderMutationResult(reminders: reminders, failures: failures);
    }

    final existing = await repository.getRemindersForPolicy(policy.id);
    final existingByKind = <ReminderTimeKind, PolicyReminder>{};
    for (final reminder in existing) {
      final current = existingByKind[reminder.timeKind];
      if (current == null || current.updatedAt.isBefore(reminder.updatedAt)) {
        existingByKind[reminder.timeKind] = reminder;
      } else {
        await repository.deleteReminderById(reminder.reminderId);
        await notificationGateway.cancelReminder(reminder.reminderId);
      }
    }

    for (final kind in uniqueKinds) {
      final schedule = scheduler.buildSchedule(policy, option: kind);
      if (schedule == null) {
        final failure = ScheduleFailure(
          type: ScheduleFailureType.invalidDate,
          message: '신청 기간 정보가 없어 알림을 설정할 수 없습니다.',
        );
        failures.add(
          ReminderMutationFailure(
            timeKind: kind,
            failure: failure,
          ),
        );
        logger.warn('Reminder for ${policy.id} skipped: ${failure.message}');
        continue;
      }
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
      final existingReminder = existingByKind[kind];

      final reminder = PolicyReminder(
        reminderId: reminderId,
        policyId: policy.id,
        scheduledAt: schedule.scheduledAt,
        createdAt: existingReminder?.createdAt ?? now,
        updatedAt: now,
        timeKind: kind,
        status: schedule.status,
        isActive: schedule.status == PolicyReminderStatus.scheduled,
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

      if (scheduleResult.isDuplicate &&
          existingReminder != null &&
          existingReminder.scheduledAt == reminder.scheduledAt) {
        final refreshedReminder = existingReminder.copyWith(updatedAt: now);
        await repository.upsertReminder(refreshedReminder);
        reminders.add(refreshedReminder);
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
    if (reminder == null || reminder.status == PolicyReminderStatus.canceled) {
      return;
    }

    final now = _now().toUtc();
    final canceledReminder = reminder.copyWith(
      status: PolicyReminderStatus.canceled,
      isActive: false,
      canceledAt: now,
      updatedAt: now,
    );

    await repository.upsertReminder(canceledReminder);
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
    final now = _now().toUtc();
    for (final reminder in reminders) {
      final result = await notificationGateway.cancelReminder(reminder.reminderId);
      if (!result.success) {
        logger.warn(
          'Failed to cancel reminder ${reminder.reminderId}: ${result.failure?.message}',
        );
      }

      final canceledReminder = reminder.copyWith(
        status: PolicyReminderStatus.canceled,
        isActive: false,
        canceledAt: now,
        updatedAt: now,
      );
      await repository.upsertReminder(canceledReminder);
    }
    if (reminders.isNotEmpty) {
      eventBus.emit(PolicyEvent(
        PolicyEventType.reminderChanged,
        policyId: policyId,
      ));
    }
  }

  Future<List<PolicyReminder>> cleanupExpiredReminders() async {
    final all = await repository.getAllReminders();
    final now = _now().toUtc();
    final updated = <PolicyReminder>[];

    for (final reminder in all) {
      if (reminder.status == PolicyReminderStatus.canceled) continue;
      if (reminder.scheduledAt.isAfter(now)) continue;

      final resolvedStatus = reminder.status == PolicyReminderStatus.expired
          ? PolicyReminderStatus.expired
          : PolicyReminderStatus.fired;
      final expiredReminder = reminder.copyWith(
        status: resolvedStatus,
        isActive: false,
        updatedAt: now,
      );
      await repository.upsertReminder(expiredReminder);
      await notificationGateway.cancelReminder(expiredReminder.reminderId);
      updated.add(expiredReminder);
    }

    if (updated.isNotEmpty) {
      eventBus.emit(const PolicyEvent(PolicyEventType.reminderBulkUpdated));
    }
    return updated;
  }

  Future<ReminderSyncReport> syncScheduledReminders() async {
    await refreshEnvironment();
    final expired = await cleanupExpiredReminders();
    final reminders = await repository.getAllReminders();
    final now = _now().toUtc();
    var rescheduledCount = 0;
    var hasUpdated = expired.isNotEmpty;
    var firedCount = expired
        .where((reminder) => reminder.status == PolicyReminderStatus.fired)
        .length;
    final failures = <ScheduleFailure>[];

    for (final reminder in reminders) {
      if (reminder.status == PolicyReminderStatus.canceled) {
        await notificationGateway.cancelReminder(reminder.reminderId);
        continue;
      }

      if (reminder.scheduledAt.isBefore(now)) {
        // Already marked as expired above.
        continue;
      }

      final scheduleResult = await notificationGateway.scheduleReminder(reminder);
      if (!scheduleResult.success) {
        failures.add(
          scheduleResult.failure ??
              const ScheduleFailure(
                type: ScheduleFailureType.unknown,
                message: 'Unknown scheduling failure during sync',
              ),
        );
        logger.warn(
          'Failed to reschedule reminder ${reminder.reminderId}: ${scheduleResult.failure?.message}',
        );
        continue;
      }

      rescheduledCount++;

      if (!reminder.isActive ||
          reminder.status != PolicyReminderStatus.scheduled) {
        final activeReminder = reminder.copyWith(
          status: PolicyReminderStatus.scheduled,
          isActive: true,
          updatedAt: now,
        );
        await repository.upsertReminder(activeReminder);
        hasUpdated = true;
      }
    }

    if (hasUpdated) {
      eventBus.emit(const PolicyEvent(PolicyEventType.reminderBulkUpdated));
    }

    return ReminderSyncReport(
      rescheduledCount: rescheduledCount,
      expiredCount: expired
          .where((reminder) => reminder.status == PolicyReminderStatus.expired)
          .length,
      firedCount: firedCount,
      failures: failures,
    );
  }

  Future<ReminderMutationResult> reconcileRemindersWithPolicy(
    Policy policy,
  ) async {
    final existing = await repository.getRemindersForPolicy(policy.id);
    final activeKinds = existing
        .where((reminder) => reminder.status == PolicyReminderStatus.scheduled)
        .map((reminder) => reminder.timeKind)
        .toSet();

    if (activeKinds.isEmpty) {
      return const ReminderMutationResult(reminders: [], failures: []);
    }

    final result = await createRemindersForPolicy(policy, activeKinds.toList());
    final failedKinds = result.failures.map((failure) => failure.timeKind).toSet();

    for (final reminder in existing) {
      if (failedKinds.contains(reminder.timeKind) &&
          reminder.status == PolicyReminderStatus.scheduled) {
        await cancelReminder(reminder.reminderId);
      }
    }

    return result;
  }
}
