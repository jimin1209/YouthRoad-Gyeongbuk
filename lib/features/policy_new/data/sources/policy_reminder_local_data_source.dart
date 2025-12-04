import '../../../../data/local/isar/isar_service.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/utils/reminder_time_util.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../domain/values/reminder_time_kind.dart';
import '../local/isar/policy_reminder_isar_model.dart';

abstract class PolicyReminderLocalDataSource {
  Future<void> upsertReminder(PolicyReminder reminder);
  Future<void> deleteReminderById(String reminderId);
  Future<void> deleteRemindersByPolicy(String policyId);
  Future<PolicyReminder?> getReminder(String reminderId);
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId);
  Future<List<PolicyReminder>> getAllReminders();
}

class IsarPolicyReminderLocalDataSource
    implements PolicyReminderLocalDataSource {
  IsarPolicyReminderLocalDataSource(this._isarService);

  final IsarService _isarService;

  @override
  Future<void> upsertReminder(PolicyReminder reminder) async {
    final model = _toIsarModel(reminder);
    await _isarService.putReminder(model);
  }

  @override
  Future<void> deleteReminderById(String reminderId) async {
    await _isarService.deleteReminderById(reminderId);
  }

  @override
  Future<void> deleteRemindersByPolicy(String policyId) async {
    await _isarService.deleteRemindersByPolicy(policyId);
  }

  @override
  Future<PolicyReminder?> getReminder(String reminderId) async {
    final model = await _isarService.getReminder(reminderId);
    if (model == null) return null;
    return _toDomain(model);
  }

  @override
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId) async {
    final models = await _isarService.getRemindersForPolicy(policyId);
    return models.map(_toDomain).toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  @override
  Future<List<PolicyReminder>> getAllReminders() async {
    final models = await _isarService.getAllReminders();
    final reminders = models.map(_toDomain).toList();
    reminders.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return reminders;
  }

  PolicyReminder _toDomain(PolicyReminderIsarModel model) {
    final timeKind = ReminderTimeKind.values.firstWhere(
      (value) => value.name == model.optionCode,
      orElse: () => ReminderTimeKind.day1,
    );
    final status = PolicyReminderStatus.values.firstWhere(
      (value) => value.name == model.status,
      orElse: () => PolicyReminderStatus.scheduled,
    );

    return PolicyReminder(
      reminderId: model.reminderId,
      policyId: model.policyId,
      scheduledAt: ReminderTimeUtil.toUtc(model.scheduledAtUtc),
      createdAt: ReminderTimeUtil.toUtc(model.createdAtUtc),
      updatedAt: ReminderTimeUtil.toUtc(model.updatedAtUtc),
      timeKind: timeKind,
      status: status,
      isActive: model.isActive,
      canceledAt: model.canceledAtUtc != null
          ? ReminderTimeUtil.toUtc(model.canceledAtUtc!)
          : null,
      policyTitleSnapshot: model.policyTitleSnapshot,
    );
  }

  PolicyReminderIsarModel _toIsarModel(PolicyReminder reminder) {
    return PolicyReminderIsarModel(
      reminderId: reminder.reminderId,
      policyId: reminder.policyId,
      optionCode: reminder.timeKind.name,
      status: reminder.status.name,
      isActive: reminder.isActive,
      scheduledAtUtc: ReminderTimeUtil.toUtc(reminder.scheduledAt),
      createdAtUtc: ReminderTimeUtil.toUtc(reminder.createdAt),
      updatedAtUtc: ReminderTimeUtil.toUtc(reminder.updatedAt),
      canceledAtUtc: reminder.canceledAt == null
          ? null
          : ReminderTimeUtil.toUtc(reminder.canceledAt!),
      policyTitleSnapshot: reminder.policyTitleSnapshot,
    );
  }
}
