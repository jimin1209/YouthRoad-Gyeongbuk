import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/policy_reminder.dart';
import '../../domain/utils/reminder_time_util.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../domain/values/reminder_time_kind.dart';

abstract class PolicyReminderLocalDataSource {
  Future<void> upsertReminder(PolicyReminder reminder);
  Future<void> deleteReminderById(String reminderId);
  Future<void> deleteRemindersByPolicy(String policyId);
  Future<PolicyReminder?> getReminder(String reminderId);
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId);
  Future<List<PolicyReminder>> getAllReminders();
}

class InMemoryPolicyReminderLocalDataSource
    implements PolicyReminderLocalDataSource {
  final Map<String, PolicyReminder> _reminders = {};

  @override
  Future<void> upsertReminder(PolicyReminder reminder) async {
    _reminders[reminder.reminderId] = reminder;
  }

  @override
  Future<void> deleteReminderById(String reminderId) async {
    _reminders.remove(reminderId);
  }

  @override
  Future<void> deleteRemindersByPolicy(String policyId) async {
    _reminders.removeWhere((key, value) => value.policyId == policyId);
  }

  @override
  Future<PolicyReminder?> getReminder(String reminderId) async {
    return _reminders[reminderId];
  }

  @override
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId) async {
    return _reminders.values
        .where((reminder) => reminder.policyId == policyId)
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  @override
  Future<List<PolicyReminder>> getAllReminders() async {
    return _reminders.values.toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }
}

class SharedPrefsPolicyReminderLocalDataSource
    implements PolicyReminderLocalDataSource {
  SharedPrefsPolicyReminderLocalDataSource(this._prefs);

  static const _remindersKey = 'policy_new_reminders';

  final SharedPreferences _prefs;

  @override
  Future<void> upsertReminder(PolicyReminder reminder) async {
    final reminders = await _loadReminders();
    final updated = [
      for (final existing in reminders)
        if (existing.reminderId != reminder.reminderId) existing,
      reminder,
    ];
    await _saveReminders(updated);
  }

  @override
  Future<void> deleteReminderById(String reminderId) async {
    final reminders = await _loadReminders();
    final updated = [
      for (final reminder in reminders)
        if (reminder.reminderId != reminderId) reminder,
    ];
    await _saveReminders(updated);
  }

  @override
  Future<void> deleteRemindersByPolicy(String policyId) async {
    final reminders = await _loadReminders();
    final updated = [
      for (final reminder in reminders)
        if (reminder.policyId != policyId) reminder,
    ];
    await _saveReminders(updated);
  }

  @override
  Future<PolicyReminder?> getReminder(String reminderId) async {
    final reminders = await _loadReminders();
    for (final reminder in reminders) {
      if (reminder.reminderId == reminderId) {
        return reminder;
      }
    }
    return null;
  }

  @override
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId) async {
    final reminders = await _loadReminders();
    return reminders
        .where((reminder) => reminder.policyId == policyId)
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  @override
  Future<List<PolicyReminder>> getAllReminders() async {
    final reminders = await _loadReminders();
    reminders.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return reminders;
  }

  Future<void> _saveReminders(List<PolicyReminder> reminders) async {
    final encoded = reminders
        .map(
          (reminder) => jsonEncode(
            {
              'id': reminder.reminderId,
              'reminderId': reminder.reminderId,
              'policyId': reminder.policyId,
              'scheduledAt': ReminderTimeUtil.toUtc(reminder.scheduledAt)
                  .toIso8601String(),
              'createdAt': ReminderTimeUtil.toUtc(reminder.createdAt)
                  .toIso8601String(),
              'updatedAt': ReminderTimeUtil.toUtc(reminder.updatedAt)
                  .toIso8601String(),
              'timeKind': reminder.timeKind.name,
              'status': reminder.status.name,
            },
          ),
        )
        .toList();

    await _prefs.setStringList(_remindersKey, encoded);
  }

  Future<List<PolicyReminder>> _loadReminders() async {
    final raw = _prefs.getStringList(_remindersKey);
    if (raw == null) return [];

    return raw
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .map(_decodeReminder)
        .toList();
  }

  PolicyReminder _decodeReminder(Map<String, dynamic> map) {
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
      createdAt:
          ReminderTimeUtil.toUtc(DateTime.parse(map['createdAt'] as String)),
      updatedAt:
          ReminderTimeUtil.toUtc(DateTime.parse(map['updatedAt'] as String)),
      timeKind: timeKind,
      status: status,
    );
  }
}
