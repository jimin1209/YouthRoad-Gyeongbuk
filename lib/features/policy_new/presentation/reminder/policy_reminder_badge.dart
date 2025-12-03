import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';

class PolicyReminderBadge extends ConsumerWidget {
  const PolicyReminderBadge({super.key, required this.policyId});

  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(policyReminderControllerProvider(policyId));

    return reminderState.when(
      data: (reminders) {
        final activeReminders = reminders
            .where((reminder) => reminder.status != PolicyReminderStatus.canceled)
            .toList();
        if (activeReminders.isEmpty) return const SizedBox.shrink();
        activeReminders.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        final targetReminder = activeReminders.first;
        if (targetReminder.status == PolicyReminderStatus.canceled) {
          return const SizedBox.shrink();
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_active, size: 16, color: Colors.orange),
            const SizedBox(width: 4),
            Text(
              targetReminder.status == PolicyReminderStatus.expired
                  ? '만료'
                  : activeReminders.length > 1
                      ? '${targetReminder.timeKind.label} 외 ${activeReminders.length - 1}'
                      : targetReminder.timeKind.label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
