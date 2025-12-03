import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/policy.dart';
import '../../../domain/entities/policy_reminder.dart';
import '../../../domain/values/policy_reminder_status.dart';
import '../../../application/controllers/policy_action_controller.dart';
import '../../../application/providers.dart';

class PolicyActionBar extends ConsumerWidget {
  const PolicyActionBar({super.key, required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(policyActionControllerProvider(policy.id));
    final controller = ref.read(policyActionControllerProvider(policy.id).notifier);

    return Column(
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
            _IconActionButton(
              icon: state.isFavorite ? Icons.favorite : Icons.favorite_border,
              active: state.isFavorite,
              label: '좋아요',
              onTap: state.isProcessing
                  ? null
                  : () async => controller.toggleFavorite(policy),
            ),
            const SizedBox(width: 8),
            _IconActionButton(
              icon:
                  state.isCompared ? Icons.compare_arrows : Icons.compare_arrows_outlined,
              active: state.isCompared,
              label: '비교함',
              onTap: state.isProcessing
                  ? null
                  : () async => controller.toggleCompare(policy),
            ),
            const SizedBox(width: 8),
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
                        final opened = await controller.openPolicyLink(policy);
                        if (!opened && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('신청 페이지를 열지 못했습니다.')),
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
  final AsyncValue<PolicyReminder?> reminderState;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    if (policy.applicationEndDate == null) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.notifications_off_outlined),
        label: const Text('마감일 정보 없음'),
      );
    }

    return reminderState.when(
      data: (reminder) {
        final label = _label(reminder);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              onPressed: isProcessing
                  ? null
                  : () async {
                      final option = await _selectOption(context, reminder?.timeKind);
                      if (option != null) {
                        await controller.setReminder(policy, option);
                      }
                    },
              icon: Icon(reminder == null ? Icons.notifications : Icons.notifications_active),
              label: Text(label),
            ),
            if (reminder != null)
              TextButton(
                onPressed: isProcessing ? null : controller.cancelReminder,
                child: const Text('알림 취소'),
              ),
          ],
        );
      },
      loading: () => const Center(child: SizedBox(height: 48, child: CircularProgressIndicator())),
      error: (err, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            onPressed: isProcessing
                ? null
                : () async {
                    final option =
                        await _selectOption(context, PolicyReminderOption.values.first);
                    if (option != null) {
                      await controller.setReminder(policy, option);
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

  String _label(PolicyReminder? reminder) {
    if (reminder == null) {
      return '신청 알림 설정';
    }
    if (reminder.status == PolicyReminderStatus.expired) {
      return '알림 만료됨';
    }
    return '알림 설정됨 · ${reminder.timeKind.label}';
  }

  Future<PolicyReminderOption?> _selectOption(
    BuildContext context,
    PolicyReminderOption? current,
  ) {
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
                subtitle: const Text('신청 마감 기준으로 알림을 설정합니다'),
                onTap: () => Navigator.of(context).pop(option),
              ),
          ],
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
