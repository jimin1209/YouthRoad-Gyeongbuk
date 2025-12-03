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
      data: (reminders) {
        final activeReminders = reminders
            .where((reminder) => reminder.status != PolicyReminderStatus.canceled)
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        final hasReminder = activeReminders.isNotEmpty;
        final label = hasReminder
            ? activeReminders.length == 1
                ? _labelForReminder(activeReminders.first)
                : '${_labelForReminder(activeReminders.first)} 외 ${activeReminders.length - 1}'
            : '신청일자 알림 설정';
        final activeOptions =
            activeReminders.map((reminder) => reminder.timeKind).toSet();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final option = await _selectOption(context, activeOptions);
                if (option == null) return;
                if (activeOptions.contains(option)) {
                  await controller.cancelReminder(option);
                } else {
                  await controller.setReminder(policy, option);
                }
              },
              icon: const Icon(Icons.notifications),
              label: Text(label),
            ),
            if (hasReminder)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final reminder in activeReminders)
                    InputChip(
                      label: Text(_chipLabel(reminder)),
                      onDeleted: () => controller.cancelReminder(reminder.timeKind),
                    ),
                ],
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
    Set<PolicyReminderOption> current,
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
                  current.contains(option)
                      ? Icons.check_circle
                      : Icons.radio_button_off,
                ),
                title: Text(option.label),
                subtitle: Text(
                  current.contains(option)
                      ? '현재 설정됨 · 탭하여 해제'
                      : '신청 마감 기준 알림을 예약합니다',
                ),
                onTap: () => Navigator.of(context).pop(option),
              ),
          ],
        );
      },
    );
  }

  String _labelForReminder(PolicyReminder reminder) {
    return reminder.status == PolicyReminderStatus.expired
        ? '알림 만료됨'
        : '알림 설정됨 · ${reminder.timeKind.label}';
  }

  String _chipLabel(PolicyReminder reminder) {
    final base = reminder.timeKind.label;
    if (reminder.status == PolicyReminderStatus.expired) {
      return '$base · 만료';
    }
    return base;
  }
}
