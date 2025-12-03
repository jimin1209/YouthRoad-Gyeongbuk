import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../domain/values/reminder_time_kind.dart';

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
                final selected = await _selectOptions(context, activeOptions);
                if (selected == null) return;
                await controller.setReminders(policy, selected.toList());
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
                      onDeleted: () => controller.removeReminder(reminder.reminderId),
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

  Future<Set<ReminderTimeKind>?> _selectOptions(
    BuildContext context,
    Set<ReminderTimeKind> current,
  ) async {
    return showModalBottomSheet<Set<ReminderTimeKind>>(
      context: context,
      builder: (context) {
        final selected = {...current};
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final option in ReminderTimeKind.values)
                      CheckboxListTile(
                        value: selected.contains(option),
                        onChanged: (value) {
                          setState(() {
                            if (value ?? false) {
                              selected.add(option);
                            } else {
                              selected.remove(option);
                            }
                          });
                        },
                        title: Text(option.label),
                        subtitle: const Text('신청 마감 기준 알림을 예약합니다'),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('취소'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(selected),
                              child: const Text('저장'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
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
