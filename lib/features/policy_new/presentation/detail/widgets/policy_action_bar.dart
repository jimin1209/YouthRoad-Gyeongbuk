import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/policy.dart';
import '../../../domain/entities/policy_reminder.dart';
import '../../../domain/values/policy_reminder_status.dart';
import '../../../application/controllers/policy_action_controller.dart';
import '../../../application/controllers/policy_reminder_controller.dart';
import '../../../application/providers.dart';
import '../../utils/policy_date_formatter.dart';

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
        final subtitle = _subtitle(activeReminders);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      activeReminders.isEmpty
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle ?? '알림은 하단 버튼에서 설정할 수 있어요.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (viewState.messages.isNotEmpty) ...[
              const SizedBox(height: 6),
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
            onPressed: null,
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('알림 상태를 불러오지 못했어요'),
          ),
          Text(
            '잠시 후 다시 시도하거나 하단 버튼에서 알림을 확인해보세요.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _label(List<PolicyReminder> reminders) {
    if (reminders.isEmpty) {
      return '신청 알림이 꺼져 있어요';
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

  String? _subtitle(List<PolicyReminder> reminders) {
    if (reminders.isEmpty) {
      return null;
    }
    final next = reminders.first;
    final dateText =
        PolicyDateFormatter.formatDateTime(next.scheduledAt.toLocal());
    if (reminders.length == 1) {
      return '${next.timeKind.label} · $dateText';
    }
    return '${next.timeKind.label} 외 ${reminders.length - 1} · $dateText';
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
