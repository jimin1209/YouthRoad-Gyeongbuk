import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';
import '../../domain/values/policy_event.dart';
import '../controllers/policy_event_bus.dart';
import '../schedulers/reminder_scheduler.dart';

class PolicyReminderService {
  PolicyReminderService({
    required this.repository,
    required this.scheduler,
    required this.eventBus,
  });

  final PolicyReminderRepository repository;
  final ReminderScheduler scheduler;
  final PolicyEventBus eventBus;

  Future<PolicyReminder> upsertReminder(
    Policy policy, {
    PolicyReminderOption option = PolicyReminderOption.day1,
  }) async {
    if (policy.applicationEndDate == null) {
      throw ArgumentError('신청 마감일이 없는 정책입니다.');
    }

    final triggerAt = policy.applicationEndDate!.subtract(option.offset);
    final now = DateTime.now();
    final status = triggerAt.isBefore(now)
        ? PolicyReminderStatus.expired
        : PolicyReminderStatus.scheduled;
    final reminder = PolicyReminder(
      id: policy.id,
      policyId: policy.id,
      scheduledAt: triggerAt,
      createdAt: now,
      option: option,
      status: status,
    );

    await repository.upsert(reminder);
    if (status == PolicyReminderStatus.scheduled) {
      await scheduler.scheduleReminder(reminder);
    }
    eventBus.emit(PolicyEvent(
      PolicyEventType.reminderChanged,
      policyId: policy.id,
    ));
    return reminder;
  }

  Future<void> cancelReminder(String policyId) async {
    await repository.delete(policyId);
    await scheduler.cancelReminder(policyId);
    eventBus.emit(PolicyEvent(
      PolicyEventType.reminderChanged,
      policyId: policyId,
    ));
  }

  Future<List<PolicyReminder>> cleanupExpiredReminders() async {
    final all = await repository.getAll();
    final now = DateTime.now();
    final updated = <PolicyReminder>[];

    for (final reminder in all) {
      if (reminder.status == PolicyReminderStatus.scheduled &&
          reminder.scheduledAt.isBefore(now)) {
        final expired = reminder.copyWith(status: PolicyReminderStatus.expired);
        await repository.upsert(expired);
        updated.add(expired);
      }
    }

    if (updated.isNotEmpty) {
      eventBus.emit(const PolicyEvent(PolicyEventType.reminderBulkUpdated));
    }
    return updated;
  }
}
