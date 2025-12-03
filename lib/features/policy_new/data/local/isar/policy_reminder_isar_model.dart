import 'package:isar/isar.dart';

part 'policy_reminder_isar_model.g.dart';

@collection
class PolicyReminderIsarModel {
  PolicyReminderIsarModel({
    this.isarId = Isar.autoIncrement,
    required this.reminderId,
    required this.policyId,
    required this.timeKind,
    required this.status,
    required this.scheduledAtUtc,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.policyTitleSnapshot,
  });

  Id isarId;

  @Index(unique: true)
  String reminderId;

  @Index()
  String policyId;

  String timeKind;

  String status;

  DateTime scheduledAtUtc;

  DateTime createdAtUtc;

  DateTime updatedAtUtc;

  String? policyTitleSnapshot;
}
