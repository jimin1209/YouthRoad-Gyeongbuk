import 'package:flutter/material.dart';

import '../../../domain/entities/policy_reminder.dart';
import '../../../domain/values/reminder_type.dart';

class ReminderListItem extends StatelessWidget {
  const ReminderListItem({
    super.key,
    required this.reminder,
    required this.onDelete,
    required this.statusLabel,
  });

  final PolicyReminder reminder;
  final VoidCallback onDelete;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(reminder.type.icon, color: Colors.blueGrey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  reminder.policyTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Text(statusLabel, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(reminder.remindAt),
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              label: const Text('삭제'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final twoDigits = (int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)} ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }
}
