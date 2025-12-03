import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';

abstract class PolicyReminderLocalDataSource {
  Future<void> saveReminder(PolicyReminder reminder);
  Future<void> deleteReminder(String reminderId);
  Future<PolicyReminder?> getReminder(String reminderId);
  Future<PolicyReminder?> getReminderByPolicyAndTimeKind(
    String policyId,
    PolicyReminderOption timeKind,
  );
  Future<void> deleteReminderByPolicyAndTimeKind(
    String policyId,
    PolicyReminderOption timeKind,
  );
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId);
  Future<List<PolicyReminder>> getAllReminders();
}

class InMemoryPolicyReminderLocalDataSource
    implements PolicyReminderLocalDataSource {
  final Map<String, PolicyReminder> _reminders = {};

  @override
  Future<void> saveReminder(PolicyReminder reminder) async {
    _reminders[reminder.reminderId] = reminder;
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    _reminders.remove(reminderId);
  }

  @override
  Future<PolicyReminder?> getReminder(String reminderId) async {
    return _reminders[reminderId];
  }

  @override
  Future<PolicyReminder?> getReminderByPolicyAndTimeKind(
    String policyId,
    PolicyReminderOption timeKind,
  ) async {
    for (final reminder in _reminders.values) {
      if (reminder.policyId == policyId && reminder.timeKind == timeKind) {
        return reminder;
      }
    }
    return null;
  }

  @override
  Future<void> deleteReminderByPolicyAndTimeKind(
    String policyId,
    PolicyReminderOption timeKind,
  ) async {
    final target = await getReminderByPolicyAndTimeKind(policyId, timeKind);
    if (target != null) {
      _reminders.remove(target.reminderId);
    }
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
  Future<void> saveReminder(PolicyReminder reminder) async {
    final reminders = await _loadReminders();
    final updated = [
      for (final existing in reminders)
        if (existing.reminderId != reminder.reminderId) existing,
      reminder,
    ];
    await _saveReminders(updated);
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    final reminders = await _loadReminders();
    final updated = [
      for (final reminder in reminders)
        if (reminder.reminderId != reminderId) reminder,
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
  Future<PolicyReminder?> getReminderByPolicyAndTimeKind(
    String policyId,
    PolicyReminderOption timeKind,
  ) async {
    final reminders = await _loadReminders();
    for (final reminder in reminders) {
      if (reminder.policyId == policyId && reminder.timeKind == timeKind) {
        return reminder;
      }
    }
    return null;
  }

  @override
  Future<void> deleteReminderByPolicyAndTimeKind(
    String policyId,
    PolicyReminderOption timeKind,
  ) async {
    final reminders = await _loadReminders();
    final updated = [
      for (final reminder in reminders)
        if (reminder.policyId != policyId || reminder.timeKind != timeKind)
          reminder,
    ];
    await _saveReminders(updated);
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
              'scheduledAt': reminder.scheduledAt.toUtc().toIso8601String(),
              'createdAt': reminder.createdAt.toUtc().toIso8601String(),
              'updatedAt': reminder.updatedAt.toUtc().toIso8601String(),
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

    final timeKind = PolicyReminderOption.values.firstWhere(
      (option) => option.name == timeKindValue,
      orElse: () => PolicyReminderOption.day1,
    );

    final status = PolicyReminderStatus.values.firstWhere(
      (value) => value.name == statusValue,
      orElse: () => PolicyReminderStatus.scheduled,
    );

    return PolicyReminder(
      reminderId: reminderId,
      policyId: map['policyId'] as String,
      scheduledAt: DateTime.parse(map['scheduledAt'] as String).toUtc(),
      createdAt: DateTime.parse(map['createdAt'] as String).toUtc(),
      updatedAt: DateTime.parse(map['updatedAt'] as String).toUtc(),
      timeKind: timeKind,
      status: status,
    );
  }
}
