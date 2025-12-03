import '../../domain/entities/policy_reminder.dart';

abstract class PolicyReminderLocalSource {
  Future<List<PolicyReminder>> fetchAllReminders();

  Future<List<PolicyReminder>> fetchRemindersForPolicy(String policyId);

  Future<void> saveReminder(PolicyReminder reminder);

  Future<void> deleteReminder(String reminderId);
}

class InMemoryPolicyReminderLocalSource implements PolicyReminderLocalSource {
  final List<PolicyReminder> _storage = [];

  @override
  Future<void> deleteReminder(String reminderId) async {
    _storage.removeWhere((reminder) => reminder.id == reminderId);
  }

  @override
  Future<List<PolicyReminder>> fetchAllReminders() async {
    return List.unmodifiable(_storage);
  }

  @override
  Future<List<PolicyReminder>> fetchRemindersForPolicy(String policyId) async {
    return _storage
        .where((reminder) => reminder.policyId == policyId)
        .toList(growable: false);
  }

  @override
  Future<void> saveReminder(PolicyReminder reminder) async {
    _storage.removeWhere((existing) => existing.id == reminder.id);
    _storage.add(reminder);
  }
}
