import '../entities/policy_reminder.dart';

abstract class PolicyReminderRepository {
  Future<void> upsertReminder(PolicyReminder reminder);
  Future<void> deleteReminderById(String reminderId);
  Future<void> deleteRemindersByPolicy(String policyId);
  Future<PolicyReminder?> getReminder(String reminderId);
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId);
  Future<List<PolicyReminder>> getAllReminders();
}
