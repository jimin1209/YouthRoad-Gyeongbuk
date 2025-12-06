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
    final subtitle =
        '${reminder.timeKind.label} · 예정 시각: ${reminder.scheduledAt.toLocal()}';

    return ListTile(
      leading: Icon(iconData, color: iconColor),
      title: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              reminder.status.label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: reminder.status == PolicyReminderStatus.canceled
                  ? null
                  : onCancel,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              child: const Text('취소'),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
