import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers.dart';
import '../../../domain/entities/policy.dart';
import '../../../domain/values/reminder_type.dart';

class ReminderSetupBottomSheet extends ConsumerStatefulWidget {
  const ReminderSetupBottomSheet({
    super.key,
    required this.policy,
  });

  final Policy policy;

  @override
  ConsumerState<ReminderSetupBottomSheet> createState() =>
      _ReminderSetupBottomSheetState();
}

class _ReminderSetupBottomSheetState
    extends ConsumerState<ReminderSetupBottomSheet> {
  ReminderType? selected;

  @override
  Widget build(BuildContext context) {
    final policy = widget.policy;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '신청 알림 설정',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (policy.applicationEndDate == null)
              const Text('마감일 정보가 없어 알림을 설정할 수 없습니다.')
            else
              ...ReminderType.values
                  .where((type) => type != ReminderType.custom)
                  .map(
                    (type) => RadioListTile<ReminderType>(
                      title: Text(type.label),
                      value: type,
                      groupValue: selected,
                      onChanged: (value) {
                        setState(() {
                          selected = value;
                        });
                      },
                    ),
                  ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: selected == null
                        ? null
                        : () async {
                            final controller =
                                ref.read(reminderControllerProvider);
                            final reminder = await controller.createReminder(
                              policy,
                              selected!,
                            );
                            if (!mounted) return;
                            Navigator.of(context).pop();
                            if (reminder == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('이미 지난 시각에는 알림을 설정할 수 없어요.'),
                                ),
                              );
                              return;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('알림이 예약되었습니다.'),
                              ),
                            );
                          },
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
