import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/policy.dart';
import '../../../domain/entities/policy_reminder.dart';
import '../../../domain/values/policy_reminder_status.dart';
import '../../../domain/values/reminder_time_kind.dart';
import '../../../application/controllers/policy_action_controller.dart';
import '../../../application/controllers/policy_reminder_controller.dart';
import '../../../application/providers.dart';
import '../../utils/policy_date_formatter.dart';
import '../../../../ui/theme/app_text.dart';

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

              Row(
                children: [
                  Expanded(
                    child: PolicyActionButton(
                      icon: state.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      label: '찜하기',
                      active: state.isFavorite,
                      onPressed: state.isProcessing
                          ? null
                          : () async => controller.toggleFavorite(policy),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PolicyActionButton(
                      icon: state.isCompared
                          ? Icons.compare_arrows
                          : Icons.compare_arrows_outlined,
                      label: '비교함',
                      active: state.isCompared,
                      onPressed: state.isProcessing
                          ? null
                          : () async => controller.toggleCompare(policy),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
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
                    child: PolicyActionButton(
                      icon: Icons.open_in_new,
                      label: '신청 페이지 열기',
                      description: '정책 안내 페이지로 이동',
                      variant: PolicyActionButtonVariant.primary,
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
      return PolicyActionButton(
        icon: Icons.notifications_off_outlined,
        label: '신청 일정 없음',
        description: '알림을 설정할 일정 정보가 없어요',
        onPressed: null,
      );
    }

    if (isClosed) {
      return PolicyActionButton(
        icon: Icons.notifications_off_outlined,
        label: '마감된 정책입니다',
        description: '마감된 정책은 알림을 설정할 수 없어요',
        onPressed: null,
      );
    }

    return reminderState.when(
      data: (viewState) {
        final reminders = [...viewState.reminders]
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

        final scheduledReminders = reminders
            .where((reminder) =>
                reminder.status == PolicyReminderStatus.scheduled)
            .toList();

        final firedReminders = reminders
            .where((reminder) => reminder.status == PolicyReminderStatus.fired)
            .toList();

        final expiredReminders = reminders
            .where((reminder) => reminder.status == PolicyReminderStatus.expired)
            .toList();

        final canceledReminders = reminders
            .where((reminder) => reminder.status == PolicyReminderStatus.canceled)
            .toList();

        final visibleReminders = () {
          if (scheduledReminders.isNotEmpty) return scheduledReminders;
          if (canceledReminders.isNotEmpty) return canceledReminders;
          if (firedReminders.isNotEmpty) return firedReminders;
          return expiredReminders;
        }();

        final label = _label(visibleReminders);
        final subtitle = _subtitle(visibleReminders);
        final isReminderBusy = viewState.isMutating || viewState.isRefreshing;
        final isActionBusy = isProcessing && !isReminderBusy;
        final isDisabled = isActionBusy || isReminderBusy;

        IconData resolveIcon() {
          if (scheduledReminders.isNotEmpty) return Icons.notifications_active;
          if (visibleReminders.isEmpty) return Icons.notifications_none;

          final status = visibleReminders.first.status;
          if (status == PolicyReminderStatus.canceled ||
              status == PolicyReminderStatus.expired) {
            return Icons.notifications_off_outlined;
          }
          if (status == PolicyReminderStatus.fired) {
            return Icons.notifications_active_outlined;
          }
          return Icons.notifications_none;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PolicyActionButton(
              icon: resolveIcon(),
              label: label,
              description: subtitle ??
                  (isActionBusy
                      ? '다른 작업을 처리하는 중이에요.'
                      : '마감 전에 알림을 받아보세요.'),
              onPressed: isDisabled
                  ? null
                  : () async => controller.toggleReminder(policy),
              active: scheduledReminders.isNotEmpty,
              variant: PolicyActionButtonVariant.tonal,
              trailing: isReminderBusy
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    )
                  : null,
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
      loading: () => const PolicyActionButton(
        icon: Icons.notifications_active_outlined,
        label: '알림 정보를 불러오는 중',
        trailing: SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        onPressed: null,
      ),
      error: (err, __) => PolicyActionButton(
        icon: Icons.notifications_active_outlined,
        label: '알림 상태를 불러오지 못했어요',
        description: '잠시 후 다시 시도해주세요',
        onPressed: null,
      ),
    );
  }

  String _label(List<PolicyReminder> reminders) {
    if (reminders.isEmpty) {
      return '신청 알림 받기';
    }
    final first = reminders.first;
    if (first.status == PolicyReminderStatus.expired) {
      return '알림 만료됨';
    }
    if (first.status == PolicyReminderStatus.fired) {
      return '알림 도착함';
    }
    if (first.status == PolicyReminderStatus.canceled) {
      return '알림 취소됨';
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
    if (next.status == PolicyReminderStatus.expired) {
      return '${next.timeKind.label} · $dateText · 만료됨';
    }
    if (next.status == PolicyReminderStatus.fired) {
      return '${next.timeKind.label} · $dateText · 이미 알림을 보냈어요';
    }
    if (next.status == PolicyReminderStatus.canceled) {
      return '${next.timeKind.label} · $dateText · 사용자가 취소했어요';
    }
    if (reminders.length == 1) {
      return '${next.timeKind.label} · $dateText';
    }
    return '${next.timeKind.label} 외 ${reminders.length - 1} · $dateText';
  }
}

enum PolicyActionButtonVariant { tonal, primary }

class PolicyActionButton extends StatelessWidget {
  const PolicyActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.description,
    this.onPressed,
    this.active = false,
    this.variant = PolicyActionButtonVariant.tonal,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String? description;
  final VoidCallback? onPressed;
  final bool active;
  final PolicyActionButtonVariant variant;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final enabled = onPressed != null;

    Color resolveBackground() {
      if (!enabled) return colors.surfaceVariant.withOpacity(0.6);
      if (variant == PolicyActionButtonVariant.primary) return colors.primary;
      if (active) return colors.primaryContainer;
      return colors.surfaceVariant;
    }

    Color resolveForeground() {
      if (variant == PolicyActionButtonVariant.primary) {
        return enabled ? colors.onPrimary : colors.onSurface.withOpacity(0.4);
      }
      if (!enabled) return colors.onSurface.withOpacity(0.38);
      if (active) return colors.onPrimaryContainer;
      return colors.onSurface;
    }

    final background = resolveBackground();
    final foreground = resolveForeground();

    return SizedBox(
      height: 64,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: variant == PolicyActionButtonVariant.tonal && !active
              ? BorderSide(color: colors.outlineVariant)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: foreground),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: description == null
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.textTheme.labelLarge?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (description != null)
                        Text(
                          description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.textTheme.bodySmall?.copyWith(
                            color: foreground.withOpacity(0.82),
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
