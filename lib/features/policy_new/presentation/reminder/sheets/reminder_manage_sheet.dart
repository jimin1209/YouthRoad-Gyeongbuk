import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers.dart';
import '../../../domain/entities/policy.dart';
import '../../../domain/values/reminder_status.dart';
import '../widgets/reminder_list_item.dart';

class ReminderManageSheet extends ConsumerWidget {
  const ReminderManageSheet({
    super.key,
    required this.policy,
  });

  final Policy policy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersByPolicyProvider(policy.id));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: reminders.when(
          data: (list) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '알림 관리',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (list.isEmpty)
                const Text('설정된 알림이 없습니다.')
              else
                ...list.map(
                  (reminder) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ReminderListItem(
                      reminder: reminder,
                      onDelete: () async {
                        await ref
                            .read(reminderControllerProvider)
                            .cancelReminder(reminder.id);
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      statusLabel: reminder.status.label,
                    ),
                  ),
                ),
              if (list.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      await ref
                          .read(reminderControllerProvider)
                          .cancelAllForPolicy(policy.id);
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('전체 해제'),
                  ),
                ),
            ],
          ),
          error: (err, _) => Text('알림을 불러오지 못했습니다: $err'),
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
