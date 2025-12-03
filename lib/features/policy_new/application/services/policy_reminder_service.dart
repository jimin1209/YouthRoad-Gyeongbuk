import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';
import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../domain/values/reminder_time_kind.dart';
import '../controllers/policy_event_bus.dart';
import '../gateways/notification_gateway.dart';
import 'policy_reminder_scheduler.dart';

class PolicyReminderService {
  PolicyReminderService({
    required this.repository,
    required this.notificationGateway,
    required this.eventBus,
    required this.scheduler,
  });

  final PolicyReminderRepository repository;
  final NotificationGateway notificationGateway;
  final PolicyEventBus eventBus;
  final PolicyReminderScheduler scheduler;

  Future<List<PolicyReminder>> createRemindersForPolicy(
    Policy policy,
    List<ReminderTimeKind> kinds,
  ) async {
    final now = DateTime.now().toUtc();
    final reminders = <PolicyReminder>[];

    for (final kind in kinds) {
      final schedule = scheduler.buildSchedule(policy, option: kind);
      final reminderId =
          PolicyReminderIdBuilder.build(policyId: policy.id, timeKind: kind);
      final existing = await repository.getReminder(reminderId);

      final reminder = PolicyReminder(
        reminderId: reminderId,
        policyId: policy.id,
        scheduledAt: schedule.scheduledAt,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
        timeKind: kind,
        status: schedule.status,
      );

      reminders.add(reminder);
      await repository.upsertReminder(reminder);
      if (reminder.status == PolicyReminderStatus.scheduled) {
        await notificationGateway.scheduleReminder(reminder);
      }
    }

    if (reminders.isNotEmpty) {
      eventBus.emit(PolicyEvent(
        PolicyEventType.reminderChanged,
        policyId: policy.id,
      ));
    }

    return reminders;
  }

  Future<void> cancelReminder(String reminderId) async {
    final reminder = await repository.getReminder(reminderId);
    if (reminder == null) return;

    await repository.deleteReminderById(reminder.reminderId);
    await notificationGateway.cancelReminder(reminder.reminderId);
    eventBus.emit(PolicyEvent(
      PolicyEventType.reminderChanged,
      policyId: reminder.policyId,
    ));
  }

  Future<void> cancelAllByPolicy(String policyId) async {
    final reminders = await repository.getRemindersForPolicy(policyId);
    await notificationGateway.cancelAllForPolicy(policyId);
    for (final reminder in reminders) {
      await notificationGateway.cancelReminder(reminder.reminderId);
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
