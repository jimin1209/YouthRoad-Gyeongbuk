import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/values/reminder_status.dart';
import '../../domain/values/reminder_type.dart';
import '../../domain/values/policy_event.dart';
import 'policy_event_bus.dart';
import 'reminder_scheduler.dart';

class ReminderController {
  ReminderController({
    required this.repository,
    required this.scheduler,
    required this.eventBus,
  });

  final ReminderRepository repository;
  final ReminderScheduler scheduler;
  final PolicyEventBus eventBus;

  Future<PolicyReminder?> createReminder(
    Policy policy,
    ReminderType type, {
    DateTime? customDateTime,
  }) async {
    final remindAt = scheduler.calculateRemindAt(
      policy,
      type,
      customDateTime: customDateTime,
    );

    if (remindAt == null) {
      return null;
    }

    final reminder = await repository.createReminder(
      policyId: policy.id,
      policyTitle: policy.title,
      remindAt: remindAt,
      type: type,
    );

    eventBus.emit(
      PolicyEvent(
        PolicyEventType.reminderCreated,
        policyId: policy.id,
        reminderId: reminder.id,
      ),
    );
    return reminder;
  }

  Future<void> cancelReminder(String reminderId) async {
    await repository.cancelReminder(reminderId);
    eventBus.emit(
      PolicyEvent(
        PolicyEventType.reminderCanceled,
        reminderId: reminderId,
      ),
    );
  }

  Future<void> cancelAllForPolicy(String policyId) async {
    await repository.cancelAllForPolicy(policyId);
    eventBus.emit(
      PolicyEvent(
        PolicyEventType.reminderCanceled,
        policyId: policyId,
      ),
    );
  }

  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId) {
    return repository.listByPolicy(policyId);
  }

  Future<void> markAsFired(String reminderId) async {
    await repository.markAsFired(reminderId);
    eventBus.emit(
      PolicyEvent(
        PolicyEventType.reminderFired,
        reminderId: reminderId,
      ),
    );
  }

  Future<void> updateStatus(
    String reminderId,
    ReminderStatus status,
  ) async {
    await repository.updateStatus(reminderId, status);
  }
}
