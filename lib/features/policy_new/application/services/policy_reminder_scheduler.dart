import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_config.dart';
import '../../domain/values/policy_reminder_status.dart';

class PolicyReminderScheduleResult {
  const PolicyReminderScheduleResult({
    required this.triggerAt,
    required this.status,
  });

  final DateTime triggerAt;
  final PolicyReminderStatus status;
}

class PolicyReminderScheduler {
  const PolicyReminderScheduler({
    this.config = const PolicyReminderConfig(),
  });

  final PolicyReminderConfig config;

  PolicyReminderScheduleResult buildSchedule(
    Policy policy, {
    PolicyReminderOption option = PolicyReminderOption.day1,
  }) {
    final baseDate = policy.applicationEndDate ?? policy.applicationStartDate;
    if (baseDate == null) {
      throw ArgumentError('신청 기간 정보가 없는 정책입니다.');
    }

    final now = DateTime.now().toUtc();
    final triggerAt = baseDate.toUtc().subtract(option.offset);
    final status = triggerAt.isBefore(now)
        ? PolicyReminderStatus.expired
        : PolicyReminderStatus.scheduled;

    return PolicyReminderScheduleResult(
      triggerAt: triggerAt,
      status: status,
    );
  }
}
