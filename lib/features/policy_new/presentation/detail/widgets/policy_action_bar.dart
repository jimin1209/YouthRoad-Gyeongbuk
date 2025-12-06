import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/policy.dart';
import '../../../domain/entities/policy_reminder.dart';
import '../../../domain/values/policy_reminder_status.dart';
import '../../../domain/values/reminder_time_kind.dart';
import '../../../application/controllers/policy_action_controller.dart';
import '../../../application/controllers/policy_reminder_controller.dart';
import '../../../application/providers.dart';

class PolicyActionBar extends ConsumerWidget {
  const PolicyActionBar({super.key, required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(policyActionControllerProvider(policy.id));
    final controller =
        ref.read(policyActionControllerProvider(policy.id).notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 0,
            maxWidth: maxWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    state.errorMessage!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ),

              // 🔥 문제였던 부분 해결: width: double.infinity 제거
              Row(
                children: [
                  _IconActionButton(
                    icon: state.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    active: state.isFavorite,
                    label: '좋아요',
                    onTap: state.isProcessing
                        ? null
                        : () async => controller.toggleFavorite(policy),
                  ),
                  const SizedBox(width: 8),
                  _IconActionButton(
                    icon: state.isCompared
                        ? Icons.compare_arrows
                        : Icons.compare_arrows_outlined,
                    active: state.isCompared,
                    label: '비교함',
                    onTap: state.isProcessing
                        ? null
                        : () async => controller.toggleCompare(policy),
                  ),
                  const SizedBox(width: 8),

                  // 🔥 Expanded로 폭 충돌 해결
                  Expanded(
                    child: _ReminderButton(
                      policy: policy,
                      controller: controller,
                      reminderState: state.reminderState,
                      isProcessing: state.isProcessing,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: state.isProcessing
                          ? null
                          : () async {
                              final opened =
                                  await controller.openPolicyLink(policy);
                              if (!opened && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('신청 페이지를 열지 못했습니다.'),
                                  ),
                                );
                              }
                            },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('신청 페이지 열기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReminderButton extends StatelessWidget {
  const _ReminderButton({
    required this.policy,
    required this.controller,
    required this.reminderState,
    required this.isProcessing,
  });

  final Policy policy;
  final PolicyActionController controller;
  final AsyncValue<PolicyReminderViewState> reminderState;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final hasScheduleWindow = policy.applicationEndDate != null ||
        policy.applicationStartDate != null;
    final isClosed = policy.isClosed;

    if (!hasScheduleWindow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.notifications_off_outlined),
            label: const Text('신청 일정 없음'),
          ),
          const SizedBox(height: 4),
          Text(
            '신청 일정 정보가 없어 알림을 설정할 수 없습니다.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ],
      );
    }

    if (isClosed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.notifications_off_outlined),
            label: const Text('마감된 정책입니다'),
          ),
          const SizedBox(height: 4),
          Text(
            '마감된 정책은 알림을 설정할 수 없어요.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ],
      );
    }

    return reminderState.when(
      data: (viewState) {
        final activeReminders = viewState.reminders
            .where(
                (reminder) => reminder.status != PolicyReminderStatus.canceled)
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

        final label = _label(activeReminders);
        final activeOptions =
            activeReminders.map((reminder) => reminder.timeKind).toSet();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: isProcessing || viewState.isMutating
                  ? null
                  : () async {
                      final selected =
                          await _selectOptions(context, activeOptions);
                      if (selected != null) {
                        await controller.setReminderOptions(
                          policy,
                          selected.toList(),
                        );
                      }
                    },
              icon: Icon(
                activeReminders.isEmpty
                    ? Icons.notifications
                    : Icons.notifications_active,
              ),
              label: Text(label),
            ),
            if (activeReminders.isNotEmpty)
              TextButton(
                onPressed: isProcessing || viewState.isMutating
                    ? null
                    : controller.cancelReminder,
                child: const Text('알림 취소'),
              ),
            if (viewState.messages.isNotEmpty) ...[
              const SizedBox(height: 4),
              ...viewState.messages.map(
                (message) => Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const Center(
        child: SizedBox(
          height: 48,
          width: 48,
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton.icon(
            onPressed: isProcessing
                ? null
                : () async {
                    final option = await _selectOptions(context, const {});
                    if (option != null) {
                      await controller.setReminderOptions(
                        policy,
                        option.toList(),
                      );
                    }
                  },
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('알림 다시 설정'),
          ),
          Text(
            '알림 상태를 불러오지 못했습니다.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _label(List<PolicyReminder> reminders) {
    if (reminders.isEmpty) {
      return '신청 알림 설정';
    }
    final first = reminders.first;
    if (first.status == PolicyReminderStatus.expired) {
      return '알림 만료됨';
    }
    if (reminders.length == 1) {
      return '알림 설정됨 · ${first.timeKind.label}';
    }
    return '알림 설정됨 · ${first.timeKind.label} 외 ${reminders.length - 1}';
  }

  Future<Set<ReminderTimeKind>?> _selectOptions(
    BuildContext context,
    Set<ReminderTimeKind> current,
  ) {
    return showModalBottomSheet<Set<ReminderTimeKind>>(
      context: context,
      builder: (context) {
        final selected = {...current};
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SingleChildScrollView(
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
                          subtitle: const Text('신청 마감 기준으로 알림을 설정합니다'),
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _IconActionButton extends StatelessWidget {
  const _IconActionButton({
    required this.icon,
    required this.active,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: active
            ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
            : Colors.grey.shade200,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Tooltip(
            message: label,
            child: Icon(
              icon,
              color: active
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}
