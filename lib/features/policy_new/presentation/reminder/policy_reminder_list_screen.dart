import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/policy_reminder.dart';
import 'widgets/policy_reminder_list_item.dart';

class PolicyReminderListScreen extends ConsumerWidget {
  const PolicyReminderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(policyReminderListControllerProvider);
    final controller = ref.read(policyReminderListControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('내 알림 관리')),
      body: reminderState.when(
        data: (reminders) {
          if (reminders.isEmpty) {
            return const Center(child: Text('설정된 알림이 없습니다'));
          }
          return RefreshIndicator(
            onRefresh: controller.load,
            child: ListView.separated(
              itemCount: reminders.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return PolicyReminderListItem(
                  reminder: reminder,
                  onCancel: () => controller.cancelReminder(reminder.policyId),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, __) => Center(child: Text('알림을 불러오지 못했습니다: $err')),
      ),
    );
  }
}
