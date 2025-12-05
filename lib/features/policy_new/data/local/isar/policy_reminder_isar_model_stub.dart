class PolicyReminderIsarModel {
  PolicyReminderIsarModel({
    this.isarId,
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

  int? isarId;
  String reminderId;
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
