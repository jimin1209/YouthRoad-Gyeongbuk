import '../entities/policy_reminder.dart';

abstract class PolicyReminderRepository {
  Future<void> upsert(PolicyReminder reminder);
  Future<void> delete(String policyId);
  Future<PolicyReminder?> getByPolicyId(String policyId);
  Future<List<PolicyReminder>> getAll();
}
