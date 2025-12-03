enum PolicyReminderStatus {
  scheduled,
  expired,
  canceled,
}

extension PolicyReminderStatusLabel on PolicyReminderStatus {
  String get label {
    switch (this) {
      case PolicyReminderStatus.scheduled:
        return '예정';
      case PolicyReminderStatus.expired:
        return '만료';
      case PolicyReminderStatus.canceled:
        return '취소됨';
    }
  }
}
