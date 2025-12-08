import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers.dart';
import '../../application/controllers/policy_reminder_controller.dart';
import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../domain/values/reminder_time_kind.dart';
import '../utils/policy_date_formatter.dart';

class PolicyReminderButton extends ConsumerWidget {
  const PolicyReminderButton({super.key, required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (policy.applicationEndDate == null && policy.applicationStartDate == null) {
      return _UnavailableNotice(policy: policy);
    }

    final reminderState = ref.watch(policyReminderControllerProvider(policy.id));
    final controller =
        ref.read(policyReminderControllerProvider(policy.id).notifier);

    return reminderState.when(
      data: (viewState) {
        final reminders = viewState.reminders;
        final activeReminders = reminders
            .where((reminder) => reminder.status != PolicyReminderStatus.canceled)
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        final activeOptions =
            activeReminders.map((reminder) => reminder.timeKind).toSet();
        final hasActiveReminders = activeReminders.isNotEmpty;

        if (viewState.messages.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final messenger = ScaffoldMessenger.maybeOf(context);
            if (messenger != null) {
              messenger.showSnackBar(
                SnackBar(content: Text(viewState.messages.first)),
              );
              controller.clearMessages();
            }
          });
        }

        return _ReminderSheetButton(
          policy: policy,
          activeOptions: activeOptions,
          activeReminders: activeReminders,
          hasActiveReminders: hasActiveReminders,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, __) =>
          const Text('알림 상태를 불러오지 못했어요', textAlign: TextAlign.center),
    );
  }

}

class _ReminderSheetButton extends StatelessWidget {
  const _ReminderSheetButton({
    required this.policy,
    required this.activeOptions,
    required this.activeReminders,
    required this.hasActiveReminders,
  });

  final Policy policy;
  final Set<ReminderTimeKind> activeOptions;
  final List<PolicyReminder> activeReminders;
  final bool hasActiveReminders;

  @override
  Widget build(BuildContext context) {
    final buttonLabel = hasActiveReminders ? '신청 알림 관리' : '신청 알림 설정';

    return ElevatedButton.icon(
      icon: const Icon(Icons.notifications_outlined),
      label: Text(buttonLabel),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return _ReminderSheet(
              policy: policy,
              initialOptions: activeOptions,
            );
          },
        );
      },
    );
  }
}

class _ReminderSheet extends ConsumerWidget {
  const _ReminderSheet({
    required this.policy,
    required this.initialOptions,
  });

  final Policy policy;
  final Set<ReminderTimeKind> initialOptions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(policyReminderControllerProvider(policy.id));
    final controller = ref.read(policyReminderControllerProvider(policy.id).notifier);

    return reminderState.when(
      data: (viewState) {
        final activeReminders = viewState.reminders
            .where((reminder) => reminder.status != PolicyReminderStatus.canceled)
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        final activeOptions =
            activeReminders.map((reminder) => reminder.timeKind).toSet();
        final effectiveOptions = (activeOptions.isNotEmpty ||
                !viewState.isRefreshing)
            ? activeOptions
            : initialOptions;

        if (viewState.messages.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final messenger = ScaffoldMessenger.maybeOf(context);
            if (messenger != null) {
              messenger.showSnackBar(
                SnackBar(content: Text(viewState.messages.first)),
              );
              controller.clearMessages();
            }
          });
        }

        return _ReminderSheetScaffold(
          policy: policy,
          viewState: viewState,
          activeOptions: effectiveOptions,
          activeReminders: activeReminders,
          onToggleOption: (option, enabled) async {
            final next = {...effectiveOptions};
            if (enabled) {
              next.add(option);
            } else {
              next.remove(option);
            }
            final result = await controller.setReminders(policy, next.toList());
            if (result.hasFailure && context.mounted) {
              final messages = controller.state.value?.messages ?? [];
              final message =
                  messages.isNotEmpty ? messages.first : '알림을 설정하지 못했어요.';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            }
          },
          onRemove: (reminderId) => controller.removeReminder(reminderId),
          onOpenOptions: () =>
              _selectReminderOptions(context, effectiveOptions).then((selected) async {
            if (selected == null) return;
            await controller.setReminders(policy, selected.toList());
          }),
          onCancelAll: () => controller.cancelAll(),
        );
      },
      loading: () => SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, __) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Center(
          child: Text('알림 정보를 불러오지 못했어요: $err'),
        ),
      ),
    );
  }
}

class _ReminderSheetScaffold extends StatelessWidget {
  const _ReminderSheetScaffold({
    required this.policy,
    required this.viewState,
    required this.activeOptions,
    required this.activeReminders,
    required this.onToggleOption,
    required this.onOpenOptions,
    required this.onRemove,
    required this.onCancelAll,
  });

  final Policy policy;
  final PolicyReminderViewState viewState;
  final Set<ReminderTimeKind> activeOptions;
  final List<PolicyReminder> activeReminders;
  final Future<void> Function(ReminderTimeKind option, bool enabled)
      onToggleOption;
  final Future<void> Function() onOpenOptions;
  final Future<void> Function(String reminderId) onRemove;
  final Future<void> Function() onCancelAll;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final scrollController = ScrollController();
    final reminderSummary = activeReminders.isEmpty
        ? '알림이 설정되지 않았어요. 원하는 시점을 선택해보세요.'
        : '알림 ${activeReminders.length}건이 예약되어 있어요.';

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.72,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
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
                        style:
                            textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _deadlineText(policy),
                        style: textTheme.bodySmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        reminderSummary,
                        style: textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (viewState.isRefreshing)
            const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('알림 옵션 선택', style: textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final option in ReminderTimeKind.values)
                        FilterChip(
                          label: Text(option.label),
                          selected: activeOptions.contains(option),
                          onSelected: viewState.isMutating
                              ? null
                              : (value) => onToggleOption(option, value),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: viewState.isMutating ? null : onOpenOptions,
                      icon: const Icon(Icons.tune),
                      label: const Text('자세히 선택'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  Text('예약된 알림', style: textTheme.labelLarge),
                  const SizedBox(height: 12),
                  if (activeReminders.isEmpty)
                    Text(
                      '아직 알림이 없습니다. 원하는 시점을 선택해 알림을 받아보세요.',
                      style: textTheme.bodyMedium,
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activeReminders.length,
                      separatorBuilder: (_, __) => const Divider(height: 16),
                      itemBuilder: (context, index) {
                        final reminder = activeReminders[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            _iconForStatus(reminder.status),
                            color: _colorForStatus(colorScheme, reminder.status),
                          ),
                          title: Text(reminder.timeKind.label),
                          subtitle: Text(
                            PolicyDateFormatter
                                .formatDateTime(reminder.scheduledAt),
                          ),
                          trailing: IconButton(
                            onPressed: viewState.isMutating
                                ? null
                                : () => onRemove(reminder.reminderId),
                            icon: const Icon(Icons.close),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: viewState.isMutating || activeReminders.isEmpty
                        ? null
                        : () => onCancelAll(),
                    child: const Text('모든 알림 취소'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _deadlineText(Policy policy) {
  final end = policy.applicationEndDate;
  if (end == null) return '신청 마감 정보가 없습니다.';
  return PolicyDateFormatter.buildDeadlineText(end: end);
}

IconData _iconForStatus(PolicyReminderStatus status) {
  switch (status) {
    case PolicyReminderStatus.scheduled:
      return Icons.alarm_on;
    case PolicyReminderStatus.fired:
      return Icons.notifications_active;
    case PolicyReminderStatus.expired:
      return Icons.history_toggle_off;
    case PolicyReminderStatus.canceled:
      return Icons.notifications_off_outlined;
  }
}

Color _colorForStatus(ColorScheme scheme, PolicyReminderStatus status) {
  switch (status) {
    case PolicyReminderStatus.scheduled:
      return scheme.primary;
    case PolicyReminderStatus.fired:
      return scheme.secondary;
    case PolicyReminderStatus.expired:
      return scheme.tertiary;
    case PolicyReminderStatus.canceled:
      return scheme.outline;
  }
}

Future<Set<ReminderTimeKind>?> _selectReminderOptions(
  BuildContext context,
  Set<ReminderTimeKind> current,
) async {
  return showModalBottomSheet<Set<ReminderTimeKind>>(
    context: context,
    isScrollControlled: true,
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
                      subtitle: const Text('신청 마감 기준 알림을 예약해요'),
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
                            onPressed: () => Navigator.of(context).pop(selected),
                            child: const Text('선택 완료'),
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
            Text('신청 알림을 설정할 수 없어요', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '이 정책은 일정 정보가 없어 알림을 설정할 수 없습니다.',
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
