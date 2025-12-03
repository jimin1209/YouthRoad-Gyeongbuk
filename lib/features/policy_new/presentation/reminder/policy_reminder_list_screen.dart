import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../detail/policy_detail_bottom_sheet.dart';
import 'widgets/policy_reminder_list_item.dart';

class PolicyReminderListScreen extends ConsumerWidget {
  const PolicyReminderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(notificationCenterControllerProvider);
    final controller = ref.read(notificationCenterControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('내 알림 관리')),
      body: reminderState.when(
        data: (centerState) {
          if (centerState.upcoming.isEmpty && centerState.past.isEmpty) {
            return const Center(child: Text('설정된 알림이 없습니다'));
          }

          return RefreshIndicator(
            onRefresh: controller.load,
            child: ListView(
              children: [
                if (centerState.upcoming.isNotEmpty) ...[
                  const ListTile(
                    title: Text(
                      '예정된 알림',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(height: 1),
                  for (final reminder in centerState.upcoming)
                    PolicyReminderListItem(
                      reminder: reminder,
                      onCancel: () =>
                          controller.cancelReminder(reminder.policyId),
                      onTap: () =>
                          _openDetail(context: context, policyId: reminder.policyId),
                    ),
                  const Divider(height: 1),
                ],
                if (centerState.past.isNotEmpty) ...[
                  const ListTile(
                    title: Text(
                      '지난 알림',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(height: 1),
                  for (final reminder in centerState.past)
                    PolicyReminderListItem(
                      reminder: reminder,
                      onCancel: () =>
                          controller.cancelReminder(reminder.policyId),
                      onTap: () =>
                          _openDetail(context: context, policyId: reminder.policyId),
                    ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, __) => Center(child: Text('알림을 불러오지 못했습니다: $err')),
      ),
    );
  }

  void _openDetail({required BuildContext context, required String policyId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => PolicyDetailBottomSheet(policyId: policyId),
    );
  }
}
