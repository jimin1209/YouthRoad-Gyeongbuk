import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';

class PolicyReminderLocalRepository implements PolicyReminderRepository {
  final Map<String, PolicyReminder> _reminders = {};

  @override
  Future<void> delete(String policyId) async {
    _reminders.remove(policyId);
  }

  @override
  Future<List<PolicyReminder>> getAll() async {
    return _reminders.values.toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  @override
  Future<PolicyReminder?> getByPolicyId(String policyId) async {
    return _reminders[policyId];
  }

  @override
  Future<void> upsert(PolicyReminder reminder) async {
    _reminders[reminder.policyId] = reminder;
  }
}
