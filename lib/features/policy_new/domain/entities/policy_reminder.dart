import '../values/policy_reminder_option.dart';
import '../values/policy_reminder_status.dart';

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
    required this.status,
  });

  bool get isExpired => scheduledAt.isBefore(DateTime.now());

  PolicyReminder copyWith({
    String? id,
    String? policyId,
    DateTime? scheduledAt,
    DateTime? createdAt,
    PolicyReminderOption? option,
    PolicyReminderStatus? status,
  }) {
    return PolicyReminder(
      id: id ?? this.id,
      policyId: policyId ?? this.policyId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      createdAt: createdAt ?? this.createdAt,
      option: option ?? this.option,
      status: status ?? this.status,
    );
  }
}
