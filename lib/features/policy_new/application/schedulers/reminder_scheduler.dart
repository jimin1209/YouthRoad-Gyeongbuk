import '../../domain/entities/policy_reminder.dart';

abstract class ReminderScheduler {
  Future<void> scheduleReminder(PolicyReminder reminder);
  Future<void> cancelReminder(String policyId);
}

class NoOpReminderScheduler implements ReminderScheduler {
  @override
  Future<void> cancelReminder(String policyId) async {
    // no-op
    return;
  }

  @override
  Future<void> scheduleReminder(PolicyReminder reminder) async {
    // no-op
    return;
  }
}
