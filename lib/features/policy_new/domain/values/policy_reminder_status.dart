enum PolicyReminderStatus {
  scheduled,
  expired,
  canceled,
}

extension PolicyReminderStatusLabel on PolicyReminderStatus {
  String get label {
    switch (this) {
      case PolicyReminderStatus.scheduled:
        return '예정됨';
      case PolicyReminderStatus.expired:
        return '만료됨';
      case PolicyReminderStatus.canceled:
        return '해제됨';
    }
  }
}
