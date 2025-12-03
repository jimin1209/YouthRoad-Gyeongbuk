import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../detail/policy_detail_bottom_sheet.dart';

class PolicyReminderCenterScreen extends ConsumerWidget {
  const PolicyReminderCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(policyReminderListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 센터'),
      ),
      body: reminderState.when(
        data: (reminders) => _buildList(context, ref, reminders),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, __) => Center(
          child: Text('알림을 불러오지 못했습니다: $err'),
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<PolicyReminder> reminders,
  ) {
    if (reminders.isEmpty) {
      return const Center(child: Text('등록된 알림이 없습니다.'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(policyReminderListControllerProvider.notifier).load(),
      child: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          final policyAsync = ref.watch(policyDetailProvider(reminder.policyId));
          final policyTitle = policyAsync.when(
            data: (p) => p.title,
            loading: () => '불러오는 중...(${reminder.policyId})',
            error: (_, __) => '정책 ${reminder.policyId}',
          );

          return ListTile(
            leading: Icon(
              reminder.status == PolicyReminderStatus.expired
                  ? Icons.notifications_off
                  : Icons.notifications_active,
            ),
            title: Text(policyTitle),
            subtitle: Text(
              '알림 시각: ${reminder.scheduledAt.toLocal()}\n상태: ${reminder.status.label}',
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () => ref
                  .read(policyReminderListControllerProvider.notifier)
                  .removeByPolicyId(reminder.policyId),
            ),
            onTap: () => _openDetail(context, reminder.policyId),
          );
        },
      ),
    );
  }

  void _openDetail(BuildContext context, String policyId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => PolicyDetailBottomSheet(policyId: policyId),
    );
  }
}
