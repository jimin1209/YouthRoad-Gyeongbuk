import '../../domain/entities/policy_reminder.dart';

abstract class PolicyReminderLocalDataSource {
  Future<void> saveReminder(PolicyReminder reminder);
  Future<void> deleteReminder(String reminderId);
  Future<PolicyReminder?> getReminder(String reminderId);
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId);
  Future<List<PolicyReminder>> getAllReminders();
}

class InMemoryPolicyReminderLocalDataSource
    implements PolicyReminderLocalDataSource {
  final Map<String, PolicyReminder> _reminders = {};

  @override
  Future<void> saveReminder(PolicyReminder reminder) async {
    _reminders[reminder.id] = reminder;
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    _reminders.remove(reminderId);
  }

  @override
  Future<PolicyReminder?> getReminder(String reminderId) async {
    return _reminders[reminderId];
  }

  @override
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId) async {
    return _reminders.values
        .where((reminder) => reminder.policyId == policyId)
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  @override
  Future<List<PolicyReminder>> getAllReminders() async {
    return _reminders.values.toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }
}
