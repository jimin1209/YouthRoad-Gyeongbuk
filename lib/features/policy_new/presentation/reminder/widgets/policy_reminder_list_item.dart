import 'package:flutter/material.dart';

import '../../../domain/entities/policy_reminder.dart';
import '../../../domain/values/policy_reminder_status.dart';
import '../../../domain/values/reminder_time_kind.dart';

class PolicyReminderListItem extends StatelessWidget {
  const PolicyReminderListItem({
    super.key,
    required this.reminder,
    required this.onCancel,
    this.onTap,
  });

  final PolicyReminder reminder;
  final VoidCallback? onCancel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iconData = switch (reminder.status) {
      PolicyReminderStatus.expired => Icons.notifications_off,
      PolicyReminderStatus.canceled => Icons.notifications_off_outlined,
      _ => Icons.notifications_active,
    };
    final iconColor = switch (reminder.status) {
      PolicyReminderStatus.expired => Colors.grey,
      PolicyReminderStatus.canceled => Colors.grey,
      _ => Colors.orange,
    };

    final title = reminder.policyTitleSnapshot ?? reminder.policyId;
    return ListTile(
      leading: Icon(iconData, color: iconColor),
      title: Text(title),
      subtitle: Text(
        '${reminder.timeKind.label} · 예정 시각: ${reminder.scheduledAt.toLocal()}',
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(reminder.status.label),
          const SizedBox(height: 4),
          TextButton(
            onPressed: reminder.status == PolicyReminderStatus.canceled
                ? null
                : onCancel,
            child: const Text('해제'),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
