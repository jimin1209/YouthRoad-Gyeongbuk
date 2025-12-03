enum PolicyReminderStatus { scheduled, expired, cancelled }

enum PolicyReminderOption {
  day1,
  day3,
  day7,
}

class PolicyReminder {
  final String id;
  final String policyId;
  final DateTime scheduledAt;
  final DateTime createdAt;
  final PolicyReminderOption option;
  final PolicyReminderStatus status;

  const PolicyReminder({
    required this.id,
    required this.policyId,
    required this.scheduledAt,
    required this.createdAt,
    required this.option,
    this.status = PolicyReminderStatus.scheduled,
  });

  bool get isExpired => scheduledAt.isBefore(DateTime.now());

  PolicyReminder copyWith({
    DateTime? scheduledAt,
    DateTime? createdAt,
    PolicyReminderOption? option,
    PolicyReminderStatus? status,
  }) {
    return PolicyReminder(
      id: id,
      policyId: policyId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      createdAt: createdAt ?? this.createdAt,
      option: option ?? this.option,
      status: status ?? this.status,
    );
  }
}

extension PolicyReminderOptionX on PolicyReminderOption {
  Duration get offset {
    switch (this) {
      case PolicyReminderOption.day1:
        return const Duration(days: 1);
      case PolicyReminderOption.day3:
        return const Duration(days: 3);
      case PolicyReminderOption.day7:
        return const Duration(days: 7);
    }
  }

  String get label {
    switch (this) {
      case PolicyReminderOption.day1:
        return '마감 하루 전';
      case PolicyReminderOption.day3:
        return '마감 3일 전';
      case PolicyReminderOption.day7:
        return '마감 7일 전';
    }
  }
}
