import 'schedule_result.dart';

class ReminderSyncReport {
  const ReminderSyncReport({
    required this.rescheduledCount,
    required this.expiredCount,
    required this.firedCount,
    this.orphanedPlatformReminders = 0,
    this.restoredMissingReminders = 0,
    this.failures = const [],
  });

  final int rescheduledCount;
  final int expiredCount;
  final int firedCount;
  final int orphanedPlatformReminders;
  final int restoredMissingReminders;
  final List<ScheduleFailure> failures;

  bool get hasFailure => failures.isNotEmpty;
}
