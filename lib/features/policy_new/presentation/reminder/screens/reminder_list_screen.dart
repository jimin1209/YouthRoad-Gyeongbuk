import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/values/reminder_status.dart';
import '../../../application/providers.dart';
import '../widgets/reminder_empty_view.dart';
import '../widgets/reminder_list_item.dart';

class ReminderListScreen extends ConsumerWidget {
  const ReminderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(reminderListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 알림'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: reminders.when(
          data: (list) => list.isEmpty
              ? const ReminderEmptyView()
              : ListView.separated(
                  itemBuilder: (context, index) {
                    final reminder = list[index];
                    return ReminderListItem(
                      reminder: reminder,
                      onDelete: () => ref
                          .read(reminderControllerProvider)
                          .cancelReminder(reminder.id),
                      statusLabel: reminder.status.label,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: list.length,
                ),
          error: (err, _) => Center(
            child: Text('알림을 불러오지 못했습니다: $err'),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
