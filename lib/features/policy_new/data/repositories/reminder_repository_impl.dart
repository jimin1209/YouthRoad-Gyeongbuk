import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../infrastructure/notification/notification_gateway.dart';
import '../sources/reminder_local_source.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl({
    required this.localSource,
    required this.notificationGateway,
  });

  final PolicyReminderLocalSource localSource;
  final NotificationGateway notificationGateway;

  @override
  Future<void> deleteReminder(String reminderId) async {
    await localSource.deleteReminder(reminderId);
    await notificationGateway.cancelReminder(reminderId);
  }

  @override
  Future<List<PolicyReminder>> getAllReminders() async {
    return localSource.fetchAllReminders();
  }

  @override
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId) {
    return localSource.fetchRemindersForPolicy(policyId);
  }

  @override
  Future<void> saveReminder(PolicyReminder reminder) async {
    await localSource.saveReminder(reminder);
    await notificationGateway.scheduleReminder(reminder);
  }
}
