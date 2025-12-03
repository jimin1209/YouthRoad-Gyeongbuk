import '../values/policy_reminder_status.dart';

import '../values/reminder_time_kind.dart';

class PolicyReminder {
  final String reminderId;
  final String policyId;
  final DateTime scheduledAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReminderTimeKind timeKind;
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
    ReminderTimeKind? timeKind,
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
  static String build({required String policyId, required ReminderTimeKind timeKind}) {
    return '$policyId::${timeKind.name}';
  }
}
