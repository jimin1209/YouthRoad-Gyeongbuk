import 'package:flutter/material.dart';

class PolicyInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const PolicyInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.bodyLarge;
    final valueStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label, style: title)),
          Expanded(child: Text(value, style: valueStyle)),
        ],
      ),
    );
  }
}
