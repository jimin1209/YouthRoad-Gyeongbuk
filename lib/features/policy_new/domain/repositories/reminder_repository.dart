import '../entities/policy_reminder.dart';
import '../values/reminder_status.dart';
import '../values/reminder_type.dart';

abstract class ReminderRepository {
  Future<PolicyReminder> createReminder({
    required String policyId,
    required String policyTitle,
    required DateTime remindAt,
    required ReminderType type,
  });

  Future<List<PolicyReminder>> listUpcoming();
  Future<List<PolicyReminder>> listByPolicy(String policyId);
  Future<void> cancelReminder(String reminderId);
  Future<void> cancelAllForPolicy(String policyId);
  Future<void> markAsFired(String reminderId);
  Future<void> updateStatus(String reminderId, ReminderStatus status);
}
