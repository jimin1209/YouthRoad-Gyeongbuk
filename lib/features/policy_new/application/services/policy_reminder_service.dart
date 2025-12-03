import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';
import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_reminder_status.dart';
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

  Future<PolicyReminder> upsertReminder(
    Policy policy, {
    PolicyReminderOption option = PolicyReminderOption.day1,
  }) async {
    final schedule = scheduler.buildSchedule(policy, option: option);
    final now = DateTime.now().toUtc();
    final reminder = PolicyReminder(
      id: policy.id,
      policyId: policy.id,
      triggerAt: schedule.triggerAt,
      createdAt: now,
      updatedAt: now,
      timeKind: option,
      status: schedule.status,
    );

    await repository.saveReminder(reminder);
    if (reminder.status == PolicyReminderStatus.scheduled) {
      await notificationGateway.scheduleReminder(reminder);
    }
    eventBus.emit(PolicyEvent(
      PolicyEventType.reminderChanged,
      policyId: policy.id,
    ));
    return reminder;
  }

  Future<void> cancelReminderByPolicyId(String policyId) async {
    final reminder = await repository.getReminderByPolicyId(policyId);
    if (reminder == null) {
      return;
    }
    await repository.deleteReminder(reminder.id);
    await notificationGateway.cancelReminder(reminder.id);
    eventBus.emit(PolicyEvent(
      PolicyEventType.reminderChanged,
      policyId: policyId,
    ));
  }

  Future<List<PolicyReminder>> cleanupExpiredReminders() async {
    final all = await repository.getAllReminders();
    final now = DateTime.now().toUtc();
    final updated = <PolicyReminder>[];

    for (final reminder in all) {
      if (reminder.status == PolicyReminderStatus.scheduled &&
          reminder.triggerAt.isBefore(now)) {
        final expiredReminder = reminder.copyWith(
          status: PolicyReminderStatus.expired,
          updatedAt: now,
        );
        await repository.saveReminder(expiredReminder);
        await notificationGateway.cancelReminder(expiredReminder.id);
        updated.add(expiredReminder);
      }
    }

    if (updated.isNotEmpty) {
      eventBus.emit(const PolicyEvent(PolicyEventType.reminderBulkUpdated));
    }
    return updated;
  }
}
