import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';
import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_reminder_option.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../controllers/policy_event_bus.dart';
import '../../infrastructure/notification/notification_gateway.dart';

class PolicyReminderService {
  final PolicyReminderRepository repository;
  final NotificationGateway scheduler;
  final PolicyEventBus eventBus;

  PolicyReminderService({
    required this.repository,
    required this.scheduler,
    required this.eventBus,
  });

  Future<PolicyReminder?> upsertReminder({
    required Policy policy,
    PolicyReminderOption option = PolicyReminderOption.dayBefore1,
  }) async {
    if (policy.applicationEndDate == null) {
      return null;
    }

    final scheduledAt = policy.applicationEndDate!.subtract(option.offset);
    final status = scheduledAt.isAfter(DateTime.now())
        ? PolicyReminderStatus.scheduled
        : PolicyReminderStatus.expired;

    final reminder = PolicyReminder(
      id: '${policy.id}-${option.name}',
      policyId: policy.id,
      scheduledAt: scheduledAt,
      createdAt: DateTime.now(),
      option: option,
      status: status,
    );

    await repository.upsert(reminder);
    if (status == PolicyReminderStatus.scheduled) {
      await scheduler.scheduleReminder(reminder);
    }

    eventBus.emit(
      PolicyEvent(
        PolicyEventType.reminderChanged,
        policyId: policy.id,
        reminderStatus: status,
      ),
    );

    return reminder;
  }

  Future<PolicyReminder?> getReminder(String policyId) async {
    return repository.getByPolicyId(policyId);
  }

  Future<void> cancelReminderByPolicyId(String policyId) async {
    final existing = await repository.getByPolicyId(policyId);
    if (existing == null) return;

    await repository.delete(policyId);
    await scheduler.cancelReminder(existing.id);

    eventBus.emit(
      PolicyEvent(
        PolicyEventType.reminderChanged,
        policyId: policyId,
        reminderStatus: PolicyReminderStatus.canceled,
      ),
    );
  }

  Future<PolicyReminderStatus> getStatus(String policyId) async {
    final reminder = await repository.getByPolicyId(policyId);
    if (reminder == null) {
      return PolicyReminderStatus.canceled;
    }

    if (reminder.status == PolicyReminderStatus.scheduled &&
        reminder.isExpired) {
      final expired = reminder.copyWith(status: PolicyReminderStatus.expired);
      await repository.upsert(expired);
      return PolicyReminderStatus.expired;
    }

    return reminder.status;
  }

  Future<List<PolicyReminder>> getAllReminders() async {
    return repository.getAll();
  }

  Future<void> cleanupExpired() async {
    final reminders = await repository.getAll();
    for (final reminder in reminders) {
      if (reminder.status == PolicyReminderStatus.scheduled &&
          reminder.isExpired) {
        final expired = reminder.copyWith(status: PolicyReminderStatus.expired);
        await repository.upsert(expired);
      }
    }
  }
}
