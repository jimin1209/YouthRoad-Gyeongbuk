import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';
import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../controllers/policy_event_bus.dart';

class PolicyReminderService {
  PolicyReminderService({
    required this.repository,
    required this.eventBus,
  });

  final PolicyReminderRepository repository;
  final PolicyEventBus eventBus;

  Future<PolicyReminder> upsertReminder(
    Policy policy, {
    PolicyReminderOption option = PolicyReminderOption.day1,
  }) async {
    if (policy.applicationEndDate == null) {
      throw ArgumentError('신청 마감일이 없는 정책입니다.');
    }

    final now = DateTime.now().toUtc();
    final scheduledAt =
        policy.applicationEndDate!.toUtc().subtract(option.offset);
    final status = scheduledAt.isBefore(now)
        ? PolicyReminderStatus.expired
        : PolicyReminderStatus.scheduled;
    final reminder = PolicyReminder(
      id: policy.id,
      policyId: policy.id,
      scheduledAt: scheduledAt,
      createdAt: now,
      updatedAt: now,
      timeKind: option,
      status: status,
    );

    await repository.saveReminder(reminder);
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
          reminder.scheduledAt.isBefore(now)) {
        final expiredReminder = reminder.copyWith(
          status: PolicyReminderStatus.expired,
          updatedAt: now,
        );
        await repository.saveReminder(expiredReminder);
        updated.add(expiredReminder);
      }
    }

    if (updated.isNotEmpty) {
      eventBus.emit(const PolicyEvent(PolicyEventType.reminderBulkUpdated));
    }
    return updated;
  }
}
