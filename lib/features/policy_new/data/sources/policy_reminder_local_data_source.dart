import '../../domain/entities/policy_reminder.dart';

abstract class PolicyReminderLocalDataSource {
  Future<void> saveReminder(PolicyReminder reminder);
  Future<void> deleteReminder(String reminderId);
  Future<PolicyReminder?> getReminder(String reminderId);
  Future<PolicyReminder?> getReminderByPolicyId(String policyId);
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
  Future<PolicyReminder?> getReminderByPolicyId(String policyId) async {
    try {
      return _reminders.values
          .firstWhere((reminder) => reminder.policyId == policyId);
    } on StateError {
      return null;
    }
  }

  @override
  Future<List<PolicyReminder>> getAllReminders() async {
    return _reminders.values.toList()
      ..sort((a, b) => a.triggerAt.compareTo(b.triggerAt));
  }
}
