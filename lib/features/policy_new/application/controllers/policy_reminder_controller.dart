import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_option.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../services/policy_reminder_service.dart';

class PolicyReminderController
    extends StateNotifier<AsyncValue<PolicyReminder?>> {
  final PolicyReminderService service;
  final Policy policy;

  PolicyReminderController({
    required this.service,
    required this.policy,
  }) : super(const AsyncLoading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncLoading();
    final reminder = await service.getReminder(policy.id);
    state = AsyncData(reminder);
  }

  Future<void> setOption(PolicyReminderOption option) async {
    state = const AsyncLoading();
    final reminder = await service.upsertReminder(
      policy: policy,
      option: option,
    );
    state = AsyncData(reminder);
  }

  Future<void> cancel() async {
    state = const AsyncLoading();
    await service.cancelReminderByPolicyId(policy.id);
    state = const AsyncData(null);
  }

  Future<PolicyReminderStatus> status() async {
    return service.getStatus(policy.id);
  }
}

class PolicyReminderListController
    extends StateNotifier<AsyncValue<List<PolicyReminder>>> {
  final PolicyReminderService service;

  PolicyReminderListController({required this.service})
      : super(const AsyncLoading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncLoading();
    await service.cleanupExpired();
    final reminders = await service.getAllReminders();
    state = AsyncData(reminders);
  }

  Future<void> removeByPolicyId(String policyId) async {
    await service.cancelReminderByPolicyId(policyId);
    await load();
  }
}
