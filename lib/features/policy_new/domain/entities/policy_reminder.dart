class PolicyReminder {
  const PolicyReminder({
    required this.id,
    required this.policyId,
    required this.scheduledAt,
    required this.createdAt,
    required this.timeKind,
    this.status = PolicyReminderStatus.scheduled,
  });

  final String id;
  final String policyId;
  final DateTime scheduledAt;
  final DateTime createdAt;
  final ReminderTimeKind timeKind;
  final PolicyReminderStatus status;

  bool get isExpired => scheduledAt.isBefore(DateTime.now());

  PolicyReminder copyWith({
    String? id,
    String? policyId,
    DateTime? scheduledAt,
    DateTime? createdAt,
    ReminderTimeKind? timeKind,
    PolicyReminderStatus? status,
  }) {
    return PolicyReminder(
      id: id ?? this.id,
      policyId: policyId ?? this.policyId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      createdAt: createdAt ?? this.createdAt,
      timeKind: timeKind ?? this.timeKind,
      status: status ?? this.status,
    );
  }
}

enum ReminderTimeKind {
  daysBeforeDeadline,
  customDateTime,
  sameDayMorning,
  threeDaysBefore,
  sevenDaysBefore,
}

enum PolicyReminderStatus {
  scheduled,
  cancelled,
  triggered,
  expired,
}
