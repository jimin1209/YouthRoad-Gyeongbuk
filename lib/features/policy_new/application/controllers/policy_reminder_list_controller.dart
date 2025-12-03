import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy_reminder.dart';
import '../providers.dart';
import '../services/policy_reminder_service.dart';

class PolicyReminderListController
    extends StateNotifier<AsyncValue<List<PolicyReminder>>> {
  PolicyReminderListController({required this.ref})
      : super(const AsyncLoading()) {
    load();
  }

  final Ref ref;

  PolicyReminderService get _service => ref.read(policyReminderServiceProvider);

  Future<void> load() async {
    state = const AsyncLoading();
    final reminders = await ref.read(policyReminderRepositoryProvider).getAllReminders();
    state = AsyncData(reminders);
  }

  Future<void> cancelReminder(String policyId) async {
    state = const AsyncLoading();
    try {
      await _service.cancelReminderByPolicyId(policyId);
      await load();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
