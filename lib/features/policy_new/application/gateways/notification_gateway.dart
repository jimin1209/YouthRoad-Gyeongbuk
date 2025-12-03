import '../../domain/entities/policy_reminder.dart';

abstract class NotificationGateway {
  Future<void> scheduleReminder(PolicyReminder reminder);
  Future<void> cancelReminder(String reminderId);
  Future<void> cancelAllForPolicy(String policyId);
}

class NoOpNotificationGateway implements NotificationGateway {
  @override
  Future<void> cancelReminder(String reminderId) async {
    // no-op
    return;
  }

  @override
  Future<void> cancelAllForPolicy(String policyId) async {
    // no-op
    return;
  }

  @override
  Future<void> scheduleReminder(PolicyReminder reminder) async {
    // no-op
    return;
  }
}
