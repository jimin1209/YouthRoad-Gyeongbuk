import '../../domain/entities/policy_reminder.dart';

abstract class NotificationGateway {
  Future<void> scheduleReminder(PolicyReminder reminder);

  Future<void> cancelReminder(String reminderId);
}
