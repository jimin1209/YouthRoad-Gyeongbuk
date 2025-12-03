enum ReminderTimeKind { day1, day3, day7, dayOf }

extension ReminderTimeKindX on ReminderTimeKind {
  Duration get offset {
    switch (this) {
      case ReminderTimeKind.day1:
        return const Duration(days: 1);
      case ReminderTimeKind.day3:
        return const Duration(days: 3);
      case ReminderTimeKind.day7:
        return const Duration(days: 7);
      case ReminderTimeKind.dayOf:
        return Duration.zero;
    }
  }

  String get label {
    switch (this) {
      case ReminderTimeKind.day1:
        return '마감 하루 전';
      case ReminderTimeKind.day3:
        return '마감 3일 전';
      case ReminderTimeKind.day7:
        return '마감 7일 전';
      case ReminderTimeKind.dayOf:
        return '마감 당일';
    }
  }
}
