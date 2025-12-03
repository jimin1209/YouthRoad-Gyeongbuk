import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';
import '../sources/policy_reminder_local_data_source.dart';

class PolicyReminderRepositoryImpl implements PolicyReminderRepository {
  PolicyReminderRepositoryImpl(this._localDataSource);

  final PolicyReminderLocalDataSource _localDataSource;

  @override
  Future<void> deleteReminderById(String reminderId) {
    return _localDataSource.deleteReminderById(reminderId);
  }

  @override
  Future<void> deleteRemindersByPolicy(String policyId) {
    return _localDataSource.deleteRemindersByPolicy(policyId);
  }

  @override
  Future<List<PolicyReminder>> getAllReminders() {
    return _localDataSource.getAllReminders();
  }

  @override
  Future<PolicyReminder?> getReminder(String reminderId) {
    return _localDataSource.getReminder(reminderId);
  }

  @override
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId) {
    return _localDataSource.getRemindersForPolicy(policyId);
  }

  @override
  Future<void> upsertReminder(PolicyReminder reminder) {
    return _localDataSource.upsertReminder(reminder);
  }
}
