import '../../domain/entities/policy_reminder.dart';

abstract class NotificationGateway {
  Future<void> scheduleReminder(PolicyReminder reminder);
  Future<void> cancelReminder(String reminderId);
}

class NoOpNotificationGateway implements NotificationGateway {
  @override
  Future<void> cancelReminder(String reminderId) async {}

  @override
  Future<void> scheduleReminder(PolicyReminder reminder) async {}
}
