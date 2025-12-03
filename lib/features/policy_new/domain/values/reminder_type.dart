import 'package:flutter/material.dart';

enum ReminderType {
  daysBefore7,
  daysBefore3,
  daysBefore1,
  sameDayMorning,
  custom,
}

extension ReminderTypeLabel on ReminderType {
  String get label {
    switch (this) {
      case ReminderType.daysBefore7:
        return '마감 7일 전';
      case ReminderType.daysBefore3:
        return '마감 3일 전';
      case ReminderType.daysBefore1:
        return '마감 하루 전';
      case ReminderType.sameDayMorning:
        return '마감 당일 09:00';
      case ReminderType.custom:
        return '직접 설정';
    }
  }

  IconData get icon {
    switch (this) {
      case ReminderType.daysBefore7:
        return Icons.calendar_today_outlined;
      case ReminderType.daysBefore3:
        return Icons.event_available_outlined;
      case ReminderType.daysBefore1:
        return Icons.notifications_active_outlined;
      case ReminderType.sameDayMorning:
        return Icons.wb_sunny_outlined;
      case ReminderType.custom:
        return Icons.edit_calendar_outlined;
    }
  }
}
