import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/values/policy_reminder_option.dart';

class PolicyReminderOptionsSheet extends ConsumerWidget {
  const PolicyReminderOptionsSheet({
    super.key,
    required this.onSelected,
  });

  final ValueChanged<PolicyReminderOption> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultOption = ref.watch(defaultPolicyReminderOptionProvider);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '알림 시점을 선택하세요',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...PolicyReminderOption.values.map(
            (option) => RadioListTile<PolicyReminderOption>(
              value: option,
              groupValue: defaultOption,
              onChanged: (value) {
                if (value == null) return;
                onSelected(value);
                Navigator.of(context).pop();
              },
              title: Text(option.label),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
