enum PolicyReminderOption {
  dayBefore1,
  hoursBefore3,
  dayOf,
}

extension PolicyReminderOptionExtension on PolicyReminderOption {
  Duration get offset {
    switch (this) {
      case PolicyReminderOption.dayBefore1:
        return const Duration(hours: 24);
      case PolicyReminderOption.hoursBefore3:
        return const Duration(hours: 3);
      case PolicyReminderOption.dayOf:
        return Duration.zero;
    }
  }

  String get label {
    switch (this) {
      case PolicyReminderOption.dayBefore1:
        return '마감 하루 전';
      case PolicyReminderOption.hoursBefore3:
        return '마감 3시간 전';
      case PolicyReminderOption.dayOf:
        return '마감 당일';
    }
  }
}
