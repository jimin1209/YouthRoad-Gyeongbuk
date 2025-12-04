import 'package:isar/isar.dart';

part 'policy_reminder_isar_model.g.dart';

@collection
class PolicyReminderIsarModel {
  PolicyReminderIsarModel({
    this.isarId = Isar.autoIncrement,
    required this.reminderId,
    required this.policyId,
    required this.optionCode,
    required this.status,
    required this.isActive,
    required this.scheduledAtUtc,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.canceledAtUtc,
    this.policyTitleSnapshot,
  });

  Id isarId;

  @Index(unique: true)
  String reminderId;

  @Index()
  String policyId;

  String optionCode;

  String status;

  bool isActive;

  DateTime scheduledAtUtc;

  DateTime createdAtUtc;

  DateTime updatedAtUtc;

  DateTime? canceledAtUtc;

  String? policyTitleSnapshot;
}
