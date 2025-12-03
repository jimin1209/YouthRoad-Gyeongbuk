import '../../domain/entities/policy.dart';
import '../../domain/values/reminder_type.dart';

class ReminderScheduler {
  DateTime? calculateRemindAt(
    Policy policy,
    ReminderType type, {
    DateTime? customDateTime,
  }) {
    if (policy.applicationEndDate == null) {
      return null;
    }

    final endDate = policy.applicationEndDate!;
    final now = DateTime.now();
    DateTime remindAt;

    switch (type) {
      case ReminderType.daysBefore7:
        remindAt = DateTime(endDate.year, endDate.month, endDate.day, 9)
            .subtract(const Duration(days: 7));
        break;
      case ReminderType.daysBefore3:
        remindAt = DateTime(endDate.year, endDate.month, endDate.day, 9)
            .subtract(const Duration(days: 3));
        break;
      case ReminderType.daysBefore1:
        remindAt = DateTime(endDate.year, endDate.month, endDate.day, 9)
            .subtract(const Duration(days: 1));
        break;
      case ReminderType.sameDayMorning:
        remindAt = DateTime(endDate.year, endDate.month, endDate.day, 9);
        break;
      case ReminderType.custom:
        if (customDateTime == null) return null;
        remindAt = customDateTime;
        break;
    }

    if (remindAt.isBefore(now)) {
      return null;
    }
    return remindAt;
  }
}
