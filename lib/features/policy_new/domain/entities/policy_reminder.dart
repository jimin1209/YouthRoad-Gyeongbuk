import '../values/policy_reminder_status.dart';

enum PolicyReminderOption { day1, day3, day7 }

class PolicyReminder {
  final String reminderId;
  final String policyId;
  final DateTime scheduledAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PolicyReminderOption timeKind;
  final PolicyReminderStatus status;

  const PolicyReminder({
    required this.reminderId,
    required this.policyId,
    required this.scheduledAt,
    required this.createdAt,
    required this.updatedAt,
    required this.timeKind,
    this.status = PolicyReminderStatus.scheduled,
  });

  bool get isExpired => scheduledAt.isBefore(DateTime.now());

  PolicyReminder copyWith({
    DateTime? scheduledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    PolicyReminderOption? timeKind,
    PolicyReminderStatus? status,
  }) {
    return PolicyReminder(
      reminderId: reminderId,
      policyId: policyId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      timeKind: timeKind ?? this.timeKind,
      status: status ?? this.status,
    );
  }
}

class PolicyReminderIdBuilder {
  static String build({required String policyId, required PolicyReminderOption timeKind}) {
    return '$policyId|${timeKind.name}';
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
