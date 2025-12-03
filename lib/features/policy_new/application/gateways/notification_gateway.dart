import '../../domain/entities/policy_reminder.dart';

enum NotificationFailureReason {
  permissionDenied,
  scheduledInPast,
  unknown,
}

class NotificationResult {
  const NotificationResult.success()
      : success = true,
        failureReason = null;

  const NotificationResult.failure(this.failureReason)
      : success = false;

  final bool success;
  final NotificationFailureReason? failureReason;
}

abstract class NotificationGateway {
  Future<NotificationResult> scheduleReminder(PolicyReminder reminder);
  Future<NotificationResult> cancelReminder(String reminderId);
  Future<NotificationResult> cancelAllForPolicy(String policyId);
}

class NoOpNotificationGateway implements NotificationGateway {
  @override
  Future<NotificationResult> cancelReminder(String reminderId) async {
    // no-op
    return const NotificationResult.success();
  }

  @override
  Future<NotificationResult> cancelAllForPolicy(String policyId) async {
    // no-op
    return const NotificationResult.success();
  }

  @override
  Future<NotificationResult> scheduleReminder(PolicyReminder reminder) async {
    // no-op
    return const NotificationResult.success();
  }
}
