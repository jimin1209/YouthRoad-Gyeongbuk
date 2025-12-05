import 'dart:async';

import '../../models/policy_filter.dart';
import 'policy_isar_model_stub.dart';
import '../../../features/policy_new/data/local/isar/policy_reminder_isar_model_stub.dart';

class IsarService {
  const IsarService();

  Future<T> _unsupported<T>() async {
    throw UnsupportedError('Isar is not supported on Web');
  }

  Future<dynamic> get instance async => _unsupported();

  Future<List<PolicyIsarModel>> getPolicies({
    PolicyFilter filter = const PolicyFilter(),
  }) async {
    return const [];
  }

  Future<List<PolicyIsarModel>> getAllPolicies() async {
    return const [];
  }

  Future<PolicyIsarModel?> getPolicyById(String id) async {
    return null;
  }

  Future<void> putAllPolicies(List<PolicyIsarModel> policies) async {}

  Future<void> clearPolicies() async {}

  Future<List<PolicyReminderIsarModel>> getAllReminders() async {
    return const [];
  }

  Future<void> putAllReminders(
    List<PolicyReminderIsarModel> reminders,
  ) async {}

  Future<void> putReminder(PolicyReminderIsarModel reminder) async {}

  Future<void> deleteReminderById(String reminderId) async {}

  Future<void> deleteRemindersByPolicy(String policyId) async {}

  Future<PolicyReminderIsarModel?> getReminder(String reminderId) async {
    return null;
  }

  Future<List<PolicyReminderIsarModel>> getRemindersForPolicy(
    String policyId,
  ) async {
    return const [];
  }

  Future<void> clearAll() async {}

  Future<void> close() async {}
}
