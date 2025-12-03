import '../entities/policy_reminder.dart';

abstract class PolicyReminderRepository {
  Future<void> saveReminder(PolicyReminder reminder);
  Future<void> deleteReminder(String reminderId);
  Future<PolicyReminder?> getReminder(String reminderId);
  Future<PolicyReminder?> getReminderByPolicyId(String policyId);
  Future<List<PolicyReminder>> getAllReminders();
}
