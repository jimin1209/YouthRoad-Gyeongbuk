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
      appBar: AppBar(title: const Text('알림 관리')),
      body: reminderState.when(
        data: (centerState) {
          final hasData =
              centerState.upcoming.isNotEmpty || centerState.past.isNotEmpty;
          final showBusy = centerState.isLoading ||
              centerState.isOptimistic ||
              centerState.pendingActions > 0;
          return Column(
            children: [
              if (showBusy) const LinearProgressIndicator(minHeight: 2),
              if (centerState.isFailure && centerState.errorMessage != null)
                Container(
                  width: double.infinity,
                  color: Colors.red.shade50,
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    centerState.errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              Expanded(
                child: hasData
                    ? RefreshIndicator(
                        onRefresh: () => controller.load(preserveError: false),
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
                                  onCancel: showBusy
                                      ? null
                                      : () => controller
                                          .cancelReminder(reminder.reminderId),
                                  onTap: () => _openDetail(
                                      context: context, policyId: reminder.policyId),
                                ),
                              const Divider(height: 1),
                            ],
                            if (centerState.past.isNotEmpty) ...[
                              const ListTile(
                                title: Text(
                                  '지나간 알림',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Divider(height: 1),
                              for (final reminder in centerState.past)
                                PolicyReminderListItem(
                                  reminder: reminder,
                                  onCancel: showBusy
                                      ? null
                                      : () => controller
                                          .cancelReminder(reminder.reminderId),
                                  onTap: () => _openDetail(
                                      context: context, policyId: reminder.policyId),
                                ),
                            ],
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => controller.load(preserveError: false),
                        child: ListView(
                          children: const [
                            SizedBox(height: 120),
                            Center(child: Text('예정된 알림이 없습니다')),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, __) => Center(child: Text('알림을 불러오지 못했어요: $err')),
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
