import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/policy_reminder.dart';

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
                return ListTile(
                  leading: Icon(
                    reminder.status == PolicyReminderStatus.expired
                        ? Icons.notifications_off
                        : Icons.notifications_active,
                    color: reminder.status == PolicyReminderStatus.expired
                        ? Colors.grey
                        : Colors.orange,
                  ),
                  title: Text('정책 ID: ${reminder.policyId}'),
                  subtitle: Text(
                    '${reminder.option.label} · 예정 시각: ${reminder.scheduledAt.toLocal()}',
                  ),
                  trailing: Text(
                    reminder.status == PolicyReminderStatus.expired
                        ? '만료'
                        : '예정',
                  ),
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
