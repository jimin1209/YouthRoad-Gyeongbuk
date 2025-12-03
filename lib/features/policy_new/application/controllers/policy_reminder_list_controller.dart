import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy_reminder.dart';
import '../providers.dart';

class PolicyReminderListController
    extends StateNotifier<AsyncValue<List<PolicyReminder>>> {
  PolicyReminderListController({required this.ref})
      : super(const AsyncLoading()) {
    load();
  }

  final Ref ref;

  Future<void> load() async {
    state = const AsyncLoading();
    final reminders = await ref.read(policyReminderRepositoryProvider).getAll();
    state = AsyncData(reminders);
  }
}
