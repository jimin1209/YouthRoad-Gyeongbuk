import '../entities/policy_reminder.dart';

class PolicyReminderConfig {
  final Duration defaultOffset;
  final List<PolicyReminderOption> supportedOptions;

  const PolicyReminderConfig({
    this.defaultOffset = const Duration(hours: 24),
    this.supportedOptions = const [
      PolicyReminderOption.day1,
      PolicyReminderOption.day3,
      PolicyReminderOption.day7,
    ],
  });
}
