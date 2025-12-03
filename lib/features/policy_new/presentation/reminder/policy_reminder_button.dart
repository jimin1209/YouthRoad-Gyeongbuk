import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';

class PolicyReminderButton extends ConsumerWidget {
  const PolicyReminderButton({super.key, required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(policyReminderControllerProvider(policy.id));
    final controller = ref.read(policyReminderControllerProvider(policy.id).notifier);

    return reminderState.when(
      data: (reminder) {
        final hasReminder = reminder != null;
        final label = hasReminder
            ? reminder!.status == PolicyReminderStatus.expired
                ? '알림 만료됨'
                : '알림 설정됨 · ${reminder.timeKind.label}'
            : '신청일자 알림 설정';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final option = await _selectOption(context, reminder?.timeKind);
                if (option == null) return;
                await controller.setReminder(policy, option);
              },
              icon: const Icon(Icons.notifications),
              label: Text(label),
            ),
            if (hasReminder)
              TextButton(
                onPressed: controller.cancelReminder,
                child: const Text('알림 취소'),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, __) => Text('알림 상태를 불러오지 못했습니다: $err'),
    );
  }

  Future<PolicyReminderOption?> _selectOption(
    BuildContext context,
    PolicyReminderOption? current,
  ) async {
    return showModalBottomSheet<PolicyReminderOption>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in PolicyReminderOption.values)
              ListTile(
                leading: Icon(
                  option == current
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                ),
                title: Text(option.label),
                subtitle: const Text('신청 마감 기준 알림을 예약합니다'),
                onTap: () => Navigator.of(context).pop(option),
              ),
          ],
        );
      },
    );
  }
}
