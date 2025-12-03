import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/reminder_status.dart';

abstract class ReminderLocalSource {
  Future<void> save(PolicyReminder reminder);
  Future<List<PolicyReminder>> fetchAll();
  Future<void> delete(String reminderId);
  Future<void> deleteByPolicy(String policyId);
  Future<void> updateStatus(String reminderId, ReminderStatus status);
}

class InMemoryReminderLocalSource implements ReminderLocalSource {
  InMemoryReminderLocalSource();

  final List<PolicyReminder> _store = [];

  @override
  Future<void> save(PolicyReminder reminder) async {
    _store.removeWhere((r) => r.id == reminder.id);
    _store.add(reminder);
  }

  @override
  Future<List<PolicyReminder>> fetchAll() async {
    return List.unmodifiable(_store);
  }

  @override
  Future<void> delete(String reminderId) async {
    _store.removeWhere((r) => r.id == reminderId);
  }

  @override
  Future<void> deleteByPolicy(String policyId) async {
    _store.removeWhere((r) => r.policyId == policyId);
  }

  @override
  Future<void> updateStatus(String reminderId, ReminderStatus status) async {
    final index = _store.indexWhere((r) => r.id == reminderId);
    if (index == -1) {
      return;
    }
    _store[index] = _store[index].copyWith(status: status);
  }
}
