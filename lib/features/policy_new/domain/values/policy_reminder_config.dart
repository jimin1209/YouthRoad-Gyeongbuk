import 'reminder_time_kind.dart';

class PolicyReminderConfig {
  final Duration defaultOffset;
  final List<ReminderTimeKind> supportedOptions;

  const PolicyReminderConfig({
    this.defaultOffset = const Duration(hours: 24),
    this.supportedOptions = const [
      ReminderTimeKind.day1,
      ReminderTimeKind.day3,
      ReminderTimeKind.day7,
    ],
  });
}
