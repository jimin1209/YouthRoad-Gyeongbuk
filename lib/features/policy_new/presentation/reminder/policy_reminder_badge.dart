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
      data: (reminder) {
        if (reminder == null) return const SizedBox.shrink();
        if (reminder.status == PolicyReminderStatus.canceled) {
          return const SizedBox.shrink();
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_active, size: 16, color: Colors.orange),
            const SizedBox(width: 4),
            Text(
              reminder.status == PolicyReminderStatus.expired
                  ? '만료'
                  : reminder.timeKind.label,
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
