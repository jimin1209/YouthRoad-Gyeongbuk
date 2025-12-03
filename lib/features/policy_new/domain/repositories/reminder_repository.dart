import '../entities/policy_reminder.dart';

abstract class ReminderRepository {
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId);

  Future<List<PolicyReminder>> getAllReminders();

  Future<void> saveReminder(PolicyReminder reminder);

  Future<void> deleteReminder(String reminderId);
}
