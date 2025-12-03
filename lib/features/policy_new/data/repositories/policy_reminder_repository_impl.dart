import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';
import '../sources/policy_reminder_local_data_source.dart';

class PolicyReminderRepositoryImpl implements PolicyReminderRepository {
  PolicyReminderRepositoryImpl(this._localDataSource);

  final PolicyReminderLocalDataSource _localDataSource;

  @override
  Future<void> deleteReminder(String reminderId) {
    return _localDataSource.deleteReminder(reminderId);
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
  Future<PolicyReminder?> getReminderByPolicyAndTimeKind(
    String policyId,
    PolicyReminderOption timeKind,
  ) {
    return _localDataSource.getReminderByPolicyAndTimeKind(policyId, timeKind);
  }

  @override
  Future<void> deleteReminderByPolicyAndTimeKind(
    String policyId,
    PolicyReminderOption timeKind,
  ) {
    return _localDataSource.deleteReminderByPolicyAndTimeKind(policyId, timeKind);
  }

  @override
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId) {
    return _localDataSource.getRemindersForPolicy(policyId);
  }

  @override
  Future<void> saveReminder(PolicyReminder reminder) {
    return _localDataSource.saveReminder(reminder);
  }
}
