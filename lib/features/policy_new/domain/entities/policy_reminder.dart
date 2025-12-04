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
  final bool isActive;
  final DateTime? canceledAt;
  final String? policyTitleSnapshot;

  const PolicyReminder({
    required this.reminderId,
    required this.policyId,
    required this.scheduledAt,
    required this.createdAt,
    required this.updatedAt,
    required this.timeKind,
    this.status = PolicyReminderStatus.scheduled,
    this.isActive = true,
    this.canceledAt,
    this.policyTitleSnapshot,
  });

  bool get isExpired => scheduledAt.isBefore(DateTime.now());

  PolicyReminder copyWith({
    DateTime? scheduledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    ReminderTimeKind? timeKind,
    PolicyReminderStatus? status,
    bool? isActive,
    DateTime? canceledAt,
    String? policyTitleSnapshot,
  }) {
    return PolicyReminder(
      reminderId: reminderId,
      policyId: policyId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      timeKind: timeKind ?? this.timeKind,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      canceledAt: canceledAt ?? this.canceledAt,
      policyTitleSnapshot: policyTitleSnapshot ?? this.policyTitleSnapshot,
    );
  }
}
