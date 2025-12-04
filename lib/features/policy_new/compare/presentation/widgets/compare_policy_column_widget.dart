import 'package:flutter/material.dart';

import '../../../domain/entities/policy.dart';
import 'compare_remove_button.dart';

class ComparePolicyColumnWidget extends StatelessWidget {
  const ComparePolicyColumnWidget({
    super.key,
    required this.policy,
    required this.onRemove,
    required this.onTap,
    required this.width,
    this.recommendedLabel,
    this.nearestDeadlineLabel,
  });

  final Policy policy;
  final VoidCallback onRemove;
  final VoidCallback onTap;
  final double width;
  final String? recommendedLabel;
  final String? nearestDeadlineLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        policy.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CompareRemoveButton(onPressed: onRemove),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  policy.summary,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (recommendedLabel != null)
                      _chip(recommendedLabel!, color: Colors.orange.shade100),
                    if (nearestDeadlineLabel != null)
                      _chip(nearestDeadlineLabel!, color: Colors.red.shade100),
                    _chip(policy.region.name),
                    _chip(policy.category.name),
                    if (policy.isOngoing) _chip('모집중'),
                    if (policy.isUpcoming) _chip('시작 예정'),
                    if (policy.isClosed) _chip('마감'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? Colors.blueGrey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}
