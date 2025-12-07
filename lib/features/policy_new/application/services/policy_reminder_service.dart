import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';
import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_logger.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../domain/values/reminder_sync_report.dart';
import '../../domain/values/reminder_time_kind.dart';
import '../../domain/utils/reminder_id_util.dart';
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
    DateTime Function()? now,
    this.retryDelays = const [
      Duration(milliseconds: 200),
      Duration(milliseconds: 600),
    ],
    Future<void> Function(Duration)? wait,
  })  : _now = now ?? DateTime.now,
        _wait = wait ?? Future.delayed;

  final PolicyReminderRepository repository;
  final NotificationGateway notificationGateway;
  final PolicyEventBus eventBus;
  final PolicyReminderScheduler scheduler;
  final PolicyLogger logger;
  final DateTime Function() _now;
  final List<Duration> retryDelays;
  final Future<void> Function(Duration duration) _wait;

  bool _shouldRetry(ScheduleFailure? failure) {
    if (failure == null) return true;
    return failure.type == ScheduleFailureType.gatewayError ||
        failure.type == ScheduleFailureType.unknown;
  }

  Future<ScheduleResult> _scheduleWithRetry(PolicyReminder reminder) async {
    ScheduleResult? result;
    for (var attempt = 0; attempt <= retryDelays.length; attempt++) {
      try {
        result = await notificationGateway.scheduleReminder(reminder);
      } catch (e, st) {
        logger.warn(
          'scheduleReminder threw for ${reminder.reminderId}: $e\n$st',
        );
        result = ScheduleResult.failure(
          ScheduleFailure(
            type: ScheduleFailureType.unknown,
            message:
                '알림 예약 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요. ($e)',
            code: ScheduleFailureCode.internalException,
          ),
        );
      }

      if (result.success || !_shouldRetry(result.failure)) {
        return result;
      }

      if (attempt == retryDelays.length) {
        break;
      }

      final delay = retryDelays[attempt];
      logger.warn(
        'Schedule attempt ${attempt + 1} for ${reminder.reminderId} failed: ${result.failure?.message}. Retrying in ${delay.inMilliseconds}ms',
      );
      await _wait(delay);
      await refreshEnvironment();
    }

    final fallback = ScheduleResult.failure(
      ScheduleFailure(
        type: ScheduleFailureType.unknown,
        message: 'Scheduling failed with no result',
        code: ScheduleFailureCode.internalException,
      ),
    );
    final failure = result ?? fallback;
    logger.warn(
      'Scheduling permanently failed for ${reminder.reminderId}: ${failure.failure?.message}',
    );
    return failure;
  }

  Future<bool> refreshEnvironment() async {
    try {
      final ready = await notificationGateway.refreshEnvironment();
      if (!ready) {
        logger
            .warn('Notification environment not ready (permission or timezone).');
      }
      return ready;
    } catch (e, st) {
      logger.warn('Notification environment init failed: $e\n$st');
      return false;
    }
  }

  Future<ReminderMutationResult> createRemindersForPolicy(
    Policy policy,
    List<ReminderTimeKind> kinds,
  ) async {
    final nowLocal = _now();
    final now = nowLocal.toUtc();
    final reminders = <PolicyReminder>[];
    final failures = <ReminderMutationFailure>[];
    final uniqueKinds = kinds.toSet();

    final deadline = policy.applicationEndDate ?? policy.applicationStartDate;
    if (deadline != null && deadline.isBefore(nowLocal)) {
      for (final kind in uniqueKinds) {
        failures.add(
          ReminderMutationFailure(
            timeKind: kind,
            failure: const ScheduleFailure(
              type: ScheduleFailureType.invalidDate,
              message: '마감된 정책은 알림을 설정할 수 없어요.',
              code: ScheduleFailureCode.pastTime,
            ),
          ),
        );
      }
      return ReminderMutationResult(reminders: reminders, failures: failures);
    }

    final environmentReady = await refreshEnvironment();
    if (!environmentReady) {
      for (final kind in uniqueKinds) {
        failures.add(
          ReminderMutationFailure(
            timeKind: kind,
            failure: const ScheduleFailure(
              type: ScheduleFailureType.permissionDenied,
              message: 'Notification environment not ready',
              code: ScheduleFailureCode.permissionDenied,
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
        try {
          await notificationGateway.cancelReminder(reminder.reminderId);
        } catch (e, st) {
          logger.warn('Reminder cleanup cancel failed: $e\n$st');
        }
      }
    }

    for (final kind in uniqueKinds) {
      final schedule = scheduler.buildSchedule(
        policy,
        option: kind,
        now: _now(),
      );
      if (schedule == null) {
        final failure = ScheduleFailure(
          type: ScheduleFailureType.invalidDate,
          message: '신청 기간 정보가 없어 알림을 설정할 수 없습니다.',
          code: ScheduleFailureCode.invalidPolicy,
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
      if (schedule.status == PolicyReminderStatus.expired ||
          schedule.scheduledAt.isBefore(now.add(const Duration(minutes: 1)))) {
        failures.add(
          ReminderMutationFailure(
            timeKind: kind,
            failure: const ScheduleFailure(
              type: ScheduleFailureType.invalidDate,
              message: '이미 지난 시각이라 알림을 설정할 수 없어요.',
              code: ScheduleFailureCode.pastTime,
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

      ScheduleResult scheduleResult;
      try {
        scheduleResult = await _scheduleWithRetry(reminder);
      } catch (e, st) {
        scheduleResult = ScheduleResult.failure(
          const ScheduleFailure(
            type: ScheduleFailureType.unknown,
            message: '알림 예약 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.',
            code: ScheduleFailureCode.internalException,
          ),
        );
        logger.warn(
          'Notification scheduling threw for ${reminder.reminderId}: $e\n$st',
        );
      }

      if (!scheduleResult.success) {
        final failure = scheduleResult.failure ??
            const ScheduleFailure(
              type: ScheduleFailureType.unknown,
              message: 'Unknown scheduling failure',
              code: ScheduleFailureCode.internalException,
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

  Future<void> cancelReminder(
    String reminderId, {
    bool deleteFromRepository = false,
  }) async {
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

    if (deleteFromRepository) {
      await repository.deleteReminderById(reminder.reminderId);
    } else {
      await repository.upsertReminder(canceledReminder);
    }
    try {
      final result = await notificationGateway.cancelReminder(reminder.reminderId);
      if (!result.success) {
        logger.warn(
          'Failed to cancel reminder $reminderId: ${result.failure?.message}',
        );
      }
    } catch (e, st) {
      logger.warn('Cancel reminder threw for $reminderId: $e\n$st');
    }
    eventBus.emit(PolicyEvent(
      PolicyEventType.reminderChanged,
      policyId: reminder.policyId,
    ));
  }

  Future<void> cancelAllByPolicy(
    String policyId, {
    bool deleteFromRepository = false,
  }) async {
    final reminders = await repository.getRemindersForPolicy(policyId);
    try {
      final bulkResult = await notificationGateway.cancelAllForPolicy(policyId);
      if (!bulkResult.success) {
        logger.warn(
          'Failed to cancel all reminders for $policyId: ${bulkResult.failure?.message}',
        );
      }
    } catch (e, st) {
      logger.warn('Bulk cancel threw for $policyId: $e\n$st');
    }
    final now = _now().toUtc();
    for (final reminder in reminders) {
      try {
        final result =
            await notificationGateway.cancelReminder(reminder.reminderId);
        if (!result.success) {
          logger.warn(
            'Failed to cancel reminder ${reminder.reminderId}: ${result.failure?.message}',
          );
        }
      } catch (e, st) {
        logger.warn('Cancel reminder threw for ${reminder.reminderId}: $e\n$st');
      }

      if (!deleteFromRepository) {
        final canceledReminder = reminder.copyWith(
          status: PolicyReminderStatus.canceled,
          isActive: false,
          canceledAt: now,
          updatedAt: now,
        );
        await repository.upsertReminder(canceledReminder);
      }
    }

    if (deleteFromRepository) {
      await repository.deleteRemindersByPolicy(policyId);
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
      try {
        await notificationGateway.cancelReminder(expiredReminder.reminderId);
      } catch (e, st) {
        logger.warn('Cleanup cancel threw for ${expiredReminder.reminderId}: $e\n$st');
      }
      updated.add(expiredReminder);
    }

    if (updated.isNotEmpty) {
      eventBus.emit(const PolicyEvent(PolicyEventType.reminderBulkUpdated));
    }
    return updated;
  }

  Future<ReminderSyncReport> syncScheduledReminders() async {
    final environmentReady = await refreshEnvironment();
    if (!environmentReady) {
      return ReminderSyncReport(
        rescheduledCount: 0,
        expiredCount: 0,
        firedCount: 0,
        failures: const [
          ScheduleFailure(
            type: ScheduleFailureType.permissionDenied,
            message: 'Notification environment not ready',
            code: ScheduleFailureCode.permissionDenied,
          ),
        ],
      );
    }
    final expired = await cleanupExpiredReminders();
    final reminders = await repository.getAllReminders();
    Set<String> scheduledIds = const {};
    try {
      scheduledIds = (await notificationGateway.listScheduledReminderIds()).toSet();
    } catch (e, st) {
      logger.warn('listScheduledReminderIds threw: $e\n$st');
      return ReminderSyncReport(
        rescheduledCount: 0,
        expiredCount: expired.length,
        firedCount: expired
            .where((reminder) => reminder.status == PolicyReminderStatus.fired)
            .length,
        failures: const [
          ScheduleFailure(
            type: ScheduleFailureType.unknown,
            message: '알림 동기화에 실패했습니다.',
            code: ScheduleFailureCode.internalException,
          ),
        ],
      );
    }
    final now = _now().toUtc();
    var rescheduledCount = 0;
    var hasUpdated = expired.isNotEmpty;
    var firedCount = expired
        .where((reminder) => reminder.status == PolicyReminderStatus.fired)
        .length;
    var orphanedPlatformReminders = 0;
    var restoredMissingReminders = 0;
    final failures = <ScheduleFailure>[];

    final reminderById = {for (final reminder in reminders) reminder.reminderId: reminder};
    final orphanedIds = scheduledIds.where((id) => !reminderById.containsKey(id));
    for (final orphanId in orphanedIds) {
      try {
        final result = await notificationGateway.cancelReminder(orphanId);
        if (!result.success) {
          failures.add(
            result.failure ??
                const ScheduleFailure(
                  type: ScheduleFailureType.unknown,
                  message: 'Unknown cancellation failure during sync',
                  code: ScheduleFailureCode.internalException,
                ),
          );
        } else {
          orphanedPlatformReminders++;
        }
      } catch (e, st) {
        logger.warn('Cancel orphan reminder threw for $orphanId: $e\n$st');
      }
    }

    for (final reminder in reminders) {
      if (reminder.status == PolicyReminderStatus.canceled) {
        try {
          await notificationGateway.cancelReminder(reminder.reminderId);
        } catch (e, st) {
          logger.warn('Cancel canceled reminder threw: $e\n$st');
        }
        continue;
      }

      if (reminder.scheduledAt.isBefore(now)) {
        // Already marked as expired above.
        continue;
      }

      final wasMissing = !scheduledIds.contains(reminder.reminderId);
      ScheduleResult scheduleResult;
      try {
        scheduleResult = await _scheduleWithRetry(reminder);
      } catch (e, st) {
        scheduleResult = ScheduleResult.failure(
          const ScheduleFailure(
            type: ScheduleFailureType.unknown,
            message: '알림 동기화 중 오류가 발생했습니다.',
            code: ScheduleFailureCode.internalException,
          ),
        );
        logger.warn('Reschedule threw for ${reminder.reminderId}: $e\n$st');
      }
      if (!scheduleResult.success) {
        failures.add(
          scheduleResult.failure ??
              const ScheduleFailure(
                type: ScheduleFailureType.unknown,
                message: 'Unknown scheduling failure during sync',
                code: ScheduleFailureCode.internalException,
              ),
        );
        logger.warn(
          'Failed to reschedule reminder ${reminder.reminderId}: ${scheduleResult.failure?.message}',
        );
        continue;
      }

      rescheduledCount++;
      if (wasMissing) {
        restoredMissingReminders++;
        hasUpdated = true;
      }

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
      orphanedPlatformReminders: orphanedPlatformReminders,
      restoredMissingReminders: restoredMissingReminders,
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
