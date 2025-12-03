import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/policy.dart';
import '../../domain/values/policy_reminder_status.dart';

class PolicyReminderBadge extends ConsumerWidget {
  const PolicyReminderBadge({super.key, required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(policyReminderControllerProvider(policy));
    final reminder = reminderState.valueOrNull;

    if (reminder == null) return const SizedBox.shrink();
    final status = reminder.status;

    final (icon, color) = switch (status) {
      PolicyReminderStatus.scheduled => (Icons.notifications_active, Colors.blue),
      PolicyReminderStatus.expired => (Icons.notifications_off, Colors.orange),
      PolicyReminderStatus.canceled => (Icons.notifications_none, Colors.grey),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          status.label,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
