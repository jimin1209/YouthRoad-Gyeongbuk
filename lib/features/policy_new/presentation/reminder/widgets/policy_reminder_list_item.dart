import 'package:flutter/material.dart';

import '../../../domain/entities/policy_reminder.dart';
import '../../../domain/values/policy_reminder_status.dart';

class PolicyReminderListItem extends StatelessWidget {
  const PolicyReminderListItem({
    super.key,
    required this.reminder,
    required this.onCancel,
  });

  final PolicyReminder reminder;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final iconData = reminder.status == PolicyReminderStatus.expired
        ? Icons.notifications_off
        : Icons.notifications_active;
    final iconColor = reminder.status == PolicyReminderStatus.expired
        ? Colors.grey
        : Colors.orange;

    return ListTile(
      leading: Icon(iconData, color: iconColor),
      title: Text('정책 ID: ${reminder.policyId}'),
      subtitle: Text(
        '${reminder.timeKind.label} · 예정 시각: ${reminder.triggerAt.toLocal()}',
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(reminder.status.label),
          const SizedBox(height: 4),
          TextButton(
            onPressed: onCancel,
            child: const Text('해제'),
          ),
        ],
      ),
    );
  }
}
