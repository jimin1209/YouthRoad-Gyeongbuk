import 'package:flutter/material.dart';

class PolicyQuerySummary extends StatelessWidget {
  const PolicyQuerySummary({
    super.key,
    required this.summary,
    required this.conditionSummary,
    required this.onReset,
    this.onTap,
    this.showConditionSummary = true,
  });

  final String summary;
  final String conditionSummary;
  final VoidCallback onReset;
  final VoidCallback? onTap;
  final bool showConditionSummary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (showConditionSummary && conditionSummary.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    conditionSummary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.black54),
                  ),
                ],
              ],
            ),
          ),
          TextButton(
            onPressed: onReset,
            child: const Text('초기화'),
          ),
        ],
      ),
    );
  }
}
