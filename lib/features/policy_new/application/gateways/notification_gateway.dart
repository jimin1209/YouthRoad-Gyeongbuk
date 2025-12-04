import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/schedule_result.dart';

abstract class NotificationGateway {
  Future<ScheduleResult> scheduleReminder(PolicyReminder reminder);
  Future<ScheduleResult> cancelReminder(String reminderId);
  Future<ScheduleResult> cancelAllForPolicy(String policyId);
  Future<Set<String>> listScheduledReminderIds();
  Future<bool> refreshEnvironment();
}

class NoOpNotificationGateway implements NotificationGateway {
  @override
  Future<ScheduleResult> cancelReminder(String reminderId) async {
    // no-op
    return ScheduleResult.success();
  }

  @override
  Future<ScheduleResult> cancelAllForPolicy(String policyId) async {
    // no-op
    return ScheduleResult.success();
  }

  @override
  Future<ScheduleResult> scheduleReminder(PolicyReminder reminder) async {
    // no-op
    return ScheduleResult.success(scheduledAt: reminder.scheduledAt);
  }

  @override
  Future<Set<String>> listScheduledReminderIds() async {
    return {};
  }

  @override
  Future<bool> refreshEnvironment() async {
    return true;
  }
}
