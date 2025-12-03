import '../values/reminder_status.dart';
import '../values/reminder_type.dart';

class PolicyReminder {
  final String id;
  final String policyId;
  final String policyTitle;
  final DateTime remindAt;
  final ReminderType type;
  final ReminderStatus status;
  final DateTime createdAt;

  const PolicyReminder({
    required this.id,
    required this.policyId,
    required this.policyTitle,
    required this.remindAt,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  bool get isUpcoming =>
      status == ReminderStatus.scheduled && remindAt.isAfter(DateTime.now());

  PolicyReminder copyWith({
    String? id,
    String? policyId,
    String? policyTitle,
    DateTime? remindAt,
    ReminderType? type,
    ReminderStatus? status,
    DateTime? createdAt,
  }) {
    return PolicyReminder(
      id: id ?? this.id,
      policyId: policyId ?? this.policyId,
      policyTitle: policyTitle ?? this.policyTitle,
      remindAt: remindAt ?? this.remindAt,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
