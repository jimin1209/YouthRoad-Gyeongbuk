import 'package:collection/collection.dart';

import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';

class PolicyReminderLocalRepository implements PolicyReminderRepository {
  final List<PolicyReminder> _reminders = [];

  @override
  Future<void> delete(String policyId) async {
    _reminders.removeWhere((r) => r.policyId == policyId);
  }

  @override
  Future<List<PolicyReminder>> getAll() async {
    return List.unmodifiable(_reminders);
  }

  @override
  Future<PolicyReminder?> getByPolicyId(String policyId) async {
    return _reminders.firstWhereOrNull((r) => r.policyId == policyId);
  }

  @override
  Future<void> upsert(PolicyReminder reminder) async {
    final index = _reminders.indexWhere((r) => r.policyId == reminder.policyId);
    if (index >= 0) {
      _reminders[index] = reminder;
    } else {
      _reminders.add(reminder);
    }
  }
}
