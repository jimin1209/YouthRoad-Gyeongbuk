enum ReminderStatus {
  scheduled,
  fired,
  canceled,
  expired,
}

extension ReminderStatusLabel on ReminderStatus {
  String get label {
    switch (this) {
      case ReminderStatus.scheduled:
        return '예약됨';
      case ReminderStatus.fired:
        return '완료';
      case ReminderStatus.canceled:
        return '해제됨';
      case ReminderStatus.expired:
        return '만료됨';
    }
  }
}
