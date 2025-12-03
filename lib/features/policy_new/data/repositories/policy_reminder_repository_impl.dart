import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/policy_reminder_repository.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../application/gateways/notification_gateway.dart';
import '../sources/policy_reminder_local_data_source.dart';

class PolicyReminderRepositoryImpl implements PolicyReminderRepository {
  PolicyReminderRepositoryImpl(
    this._localDataSource,
    this._notificationGateway,
  );

  final PolicyReminderLocalDataSource _localDataSource;
  final NotificationGateway _notificationGateway;

  @override
  Future<void> deleteReminder(String reminderId) async {
    await _notificationGateway.cancelReminder(reminderId);
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
  Future<PolicyReminder?> getReminderByPolicyId(String policyId) {
    return _localDataSource.getReminderByPolicyId(policyId);
  }

  @override
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId) async {
    final reminder = await getReminderByPolicyId(policyId);
    if (reminder == null) return [];
    return [reminder];
  }

  @override
  Future<void> saveReminder(PolicyReminder reminder) async {
    if (reminder.status == PolicyReminderStatus.scheduled) {
      await _notificationGateway.scheduleReminder(reminder);
    } else {
      await _notificationGateway.cancelReminder(reminder.id);
    }
    return _localDataSource.saveReminder(reminder);
  }
}
