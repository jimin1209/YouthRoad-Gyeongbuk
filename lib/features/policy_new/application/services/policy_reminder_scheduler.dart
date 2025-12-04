import '../../domain/entities/policy.dart';
import '../../domain/values/policy_reminder_config.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../domain/values/reminder_time_kind.dart';
import '../../domain/utils/reminder_time_util.dart';

class PolicyReminderScheduler {
  const PolicyReminderScheduler({
    this.config = const PolicyReminderConfig(),
    DateTime Function()? now,
  }) : _nowGetter = now ?? DateTime.now;

  final PolicyReminderConfig config;
  final DateTime Function() _nowGetter;

  PolicyReminderScheduleResult? buildSchedule(
    Policy policy, {
    ReminderTimeKind option = ReminderTimeKind.day1,
    DateTime? now,
  }) {
    final baseDate = policy.applicationEndDate ?? policy.applicationStartDate;
    if (baseDate == null) {
      return null;
    }

    final current = ReminderTimeUtil.toUtc(now ?? _nowGetter());
    final scheduledAt = ReminderTimeUtil.toUtc(baseDate).subtract(option.offset);
    final status = scheduledAt.isBefore(current)
        ? PolicyReminderStatus.expired
        : PolicyReminderStatus.scheduled;

    return PolicyReminderScheduleResult(
      scheduledAt: scheduledAt,
      status: status,
    );
  }
}

class PolicyReminderScheduleResult {
  const PolicyReminderScheduleResult({
    required this.scheduledAt,
    required this.status,
  });

  final DateTime scheduledAt;
  final PolicyReminderStatus status;
}
