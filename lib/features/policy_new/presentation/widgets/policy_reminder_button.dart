import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../application/controllers/policy_reminder_controller.dart';
import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_option.dart';
import '../../domain/values/policy_reminder_status.dart';
import 'policy_reminder_options_sheet.dart';

class PolicyReminderButton extends ConsumerWidget {
  const PolicyReminderButton({super.key, required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(policyReminderControllerProvider(policy));
    final controller = ref.read(policyReminderControllerProvider(policy).notifier);

    final reminder = reminderState.valueOrNull;
    final isLoading = reminderState.isLoading;
    final statusLabel = _buildStatusLabel(reminder);

    final hasScheduleInfo = policy.applicationEndDate != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: (!hasScheduleInfo || isLoading)
                    ? null
                    : () => _showOptions(context, controller),
                icon: const Icon(Icons.notifications),
                label: Text(statusLabel),
              ),
            ),
            const SizedBox(width: 8),
            if (reminder != null)
              TextButton(
                onPressed: isLoading ? null : controller.cancel,
                child: const Text('알림 해제'),
              ),
          ],
        ),
        if (!hasScheduleInfo)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              '신청 마감일 정보가 없어 알림을 설정할 수 없습니다.',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
        if (reminder != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '알림 예정: ${reminder.scheduledAt.toLocal()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  String _buildStatusLabel(PolicyReminder? reminder) {
    if (reminder == null) return '알림 설정';
    switch (reminder.status) {
      case PolicyReminderStatus.scheduled:
        return '알림 변경';
      case PolicyReminderStatus.expired:
        return '만료 - 다시 설정';
      case PolicyReminderStatus.canceled:
        return '알림 설정';
    }
  }

  void _showOptions(
    BuildContext context,
    PolicyReminderController controller,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => PolicyReminderOptionsSheet(
        onSelected: (option) => controller.setOption(option),
      ),
    );
  }
}
