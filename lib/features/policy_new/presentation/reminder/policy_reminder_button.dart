import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
    if (policy.applicationEndDate == null) {
      return _UnavailableNotice(policy: policy);
    }

    final reminderState = ref.watch(policyReminderControllerProvider(policy.id));
    final controller = ref.read(policyReminderControllerProvider(policy.id).notifier);

    return reminderState.when(
      data: (viewState) {
        final reminders = viewState.reminders;
        final activeReminders = reminders
            .where((reminder) => reminder.status != PolicyReminderStatus.canceled)
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        final activeOptions =
            activeReminders.map((reminder) => reminder.timeKind).toSet();

        if (viewState.messages.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final messenger = ScaffoldMessenger.maybeOf(context);
            if (messenger != null) {
              messenger.showSnackBar(
                SnackBar(content: Text(viewState.messages.first)),
              );
            }
          });
        }

        return _ReminderSection(
          policy: policy,
          reminders: activeReminders,
          isRefreshing: viewState.isRefreshing,
          isMutating: viewState.isMutating,
          activeOptions: activeOptions,
          onToggleOption: (option, enabled) async {
            final next = {...activeOptions};
            if (enabled) {
              next.add(option);
            } else {
              next.remove(option);
            }
            final result = await controller.setReminders(policy, next.toList());
            if (result.hasFailure && context.mounted) {
              final messages = controller.state.value?.messages ?? [];
              final message =
                  messages.isNotEmpty ? messages.first : '알림을 설정하지 못했습니다.';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            }
          },
          onRemove: (reminderId) => controller.removeReminder(reminderId),
          onOpenOptions: () => _selectOptions(context, activeOptions).then((selected) async {
            if (selected == null) return;
            await controller.setReminders(policy, selected.toList());
          }),
          onCancelAll: () => controller.cancelAll(),
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

}

class _ReminderSection extends StatelessWidget {
  const _ReminderSection({
    required this.policy,
    required this.reminders,
    required this.isRefreshing,
    required this.isMutating,
    required this.activeOptions,
    required this.onToggleOption,
    required this.onRemove,
    required this.onOpenOptions,
    required this.onCancelAll,
  });

  final Policy policy;
  final List<PolicyReminder> reminders;
  final bool isRefreshing;
  final bool isMutating;
  final Set<ReminderTimeKind> activeOptions;
  final Future<void> Function(ReminderTimeKind option, bool enabled) onToggleOption;
  final Future<void> Function(String reminderId) onRemove;
  final Future<void> Function() onOpenOptions;
  final Future<void> Function() onCancelAll;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardColor = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6);

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.notifications_active_outlined),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('신청 알림', style: textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        policy.title,
                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _deadlineText(),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isRefreshing) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(minHeight: 2),
            ],
            const SizedBox(height: 12),
            Text('알림 옵션', style: textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final option in ReminderTimeKind.values)
                  FilterChip(
                    label: Text(option.label),
                    selected: activeOptions.contains(option),
                    onSelected: isMutating
                        ? null
                        : (value) {
                            onToggleOption(option, value);
                          },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: isMutating
                    ? null
                    : () {
                        onOpenOptions();
                      },
                icon: const Icon(Icons.tune),
                label: const Text('세부 옵션 선택'),
              ),
            ),
            const Divider(height: 24),
            Text('예약된 알림', style: textTheme.labelLarge),
            const SizedBox(height: 8),
            if (reminders.isEmpty)
              Text(
                '아직 알림이 없습니다. 원하는 알림 시점을 선택하면 마감 전에 알려드려요.',
                style: textTheme.bodyMedium,
              )
            else
              Column(
                children: [
                  for (final reminder in reminders)
                    _ReminderTile(
                      reminder: reminder,
                      isMutating: isMutating,
                      onRemove: onRemove,
                    ),
                ],
              ),
            if (reminders.isNotEmpty) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isMutating
                      ? null
                      : () {
                          onCancelAll();
                        },
                  child: const Text('모든 알림 취소'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _deadlineText() {
    final end = policy.applicationEndDate;
    if (end == null) return '신청 마감일 정보가 없습니다.';
    final formatter = DateFormat('yyyy.MM.dd (E)');
    final local = end.toLocal();
    return '신청 마감일 · ${formatter.format(local)}';
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.reminder,
    required this.isMutating,
    required this.onRemove,
  });

  final PolicyReminder reminder;
  final bool isMutating;
  final Future<void> Function(String reminderId) onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final subtitle = _subtitle(reminder);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        _iconForStatus(reminder.status),
        color: _colorForStatus(colorScheme),
      ),
      title: Text(reminder.timeKind.label),
      subtitle: Text(subtitle, style: textTheme.bodySmall),
      trailing: reminder.status == PolicyReminderStatus.canceled
          ? null
          : IconButton(
              onPressed: isMutating ? null : () => onRemove(reminder.reminderId),
              icon: const Icon(Icons.close),
            ),
    );
  }

  String _subtitle(PolicyReminder reminder) {
    final scheduleText =
        DateFormat('yyyy.MM.dd (E) a h:mm', 'ko').format(reminder.scheduledAt.toLocal());
    final statusLabel = reminder.status.label;
    return '$scheduleText · $statusLabel';
  }

  IconData _iconForStatus(PolicyReminderStatus status) {
    switch (status) {
      case PolicyReminderStatus.scheduled:
        return Icons.alarm_on;
      case PolicyReminderStatus.expired:
        return Icons.history_toggle_off;
      case PolicyReminderStatus.canceled:
        return Icons.notifications_off_outlined;
    }
  }

  Color _colorForStatus(ColorScheme scheme) {
    switch (reminder.status) {
      case PolicyReminderStatus.scheduled:
        return scheme.primary;
      case PolicyReminderStatus.expired:
        return scheme.tertiary;
      case PolicyReminderStatus.canceled:
        return scheme.outline;
    }
  }
}

class _UnavailableNotice extends StatelessWidget {
  const _UnavailableNotice({required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('신청 알림을 사용할 수 없어요', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '이 정책은 신청 마감일 정보가 없어 알림을 설정할 수 없습니다.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              policy.title,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
