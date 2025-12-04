import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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

class LegacyReminderPrefsAdapter {
  const LegacyReminderPrefsAdapter._();

  static const remindersKey = 'policy_new_reminders';

  static List<PolicyReminder> load(SharedPreferences prefs) {
    final raw = prefs.getStringList(remindersKey);
    if (raw == null) return [];

    final reminders = <PolicyReminder>[];
    for (final item in raw) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        reminders.add(_decodeReminder(map));
      } catch (_) {
        continue;
      }
    }
    return reminders;
  }

  static PolicyReminder _decodeReminder(Map<String, dynamic> map) {
    final timeKindValue = map['timeKind'] as String?;
    final statusValue = map['status'] as String?;
    final reminderId = (map['reminderId'] as String?) ?? (map['id'] as String);

    final timeKind = ReminderTimeKind.values.firstWhere(
      (option) => option.name == timeKindValue,
      orElse: () => ReminderTimeKind.day1,
    );

    final status = PolicyReminderStatus.values.firstWhere(
      (value) => value.name == statusValue,
      orElse: () => PolicyReminderStatus.scheduled,
    );

    return PolicyReminder(
      reminderId: reminderId,
      policyId: map['policyId'] as String,
      scheduledAt:
          ReminderTimeUtil.toUtc(DateTime.parse(map['scheduledAt'] as String)),
      createdAt: ReminderTimeUtil.toUtc(DateTime.parse(map['createdAt'] as String)),
      updatedAt: ReminderTimeUtil.toUtc(DateTime.parse(map['updatedAt'] as String)),
      timeKind: timeKind,
      status: status,
      isActive: status == PolicyReminderStatus.scheduled,
    );
  }
}

class IsarPolicyReminderLocalDataSource
    implements PolicyReminderLocalDataSource {
  IsarPolicyReminderLocalDataSource(this._isarService, this._prefs);

  final IsarService _isarService;
  final SharedPreferences _prefs;
  bool _migrationDone = false;
  static const _migrationFlag = 'policy_new_reminders_migrated_v2';

  Future<void> _ensureMigrated() async {
    if (_migrationDone || _prefs.getBool(_migrationFlag) == true) {
      _migrationDone = true;
      return;
    }

    final legacy = LegacyReminderPrefsAdapter.load(_prefs);
    if (legacy.isNotEmpty) {
      final models = legacy.map(_toIsarModel).toList();
      await _isarService.putAllReminders(models);
    }

    await _prefs.setBool(_migrationFlag, true);
    await _prefs.remove(LegacyReminderPrefsAdapter.remindersKey);
    _migrationDone = true;
  }

  @override
  Future<void> upsertReminder(PolicyReminder reminder) async {
    await _ensureMigrated();
    final model = _toIsarModel(reminder);
    await _isarService.putReminder(model);
  }

  @override
  Future<void> deleteReminderById(String reminderId) async {
    await _ensureMigrated();
    await _isarService.deleteReminderById(reminderId);
  }

  @override
  Future<void> deleteRemindersByPolicy(String policyId) async {
    await _ensureMigrated();
    await _isarService.deleteRemindersByPolicy(policyId);
  }

  @override
  Future<PolicyReminder?> getReminder(String reminderId) async {
    await _ensureMigrated();
    final model = await _isarService.getReminder(reminderId);
    if (model == null) return null;
    return _toDomain(model);
  }

  @override
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId) async {
    await _ensureMigrated();
    final models = await _isarService.getRemindersForPolicy(policyId);
    return models
        .map(_toDomain)
        .where((reminder) => reminder.status != PolicyReminderStatus.canceled)
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  @override
  Future<List<PolicyReminder>> getAllReminders() async {
    await _ensureMigrated();
    final models = await _isarService.getAllReminders();
    final reminders = models
        .map(_toDomain)
        .where((reminder) => reminder.status != PolicyReminderStatus.canceled)
        .toList();
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
