import 'package:flutter/material.dart';

import '../../controllers/compare_diff_service.dart';
import '../../../domain/entities/policy.dart';
import '../../models/compare_state.dart';

class CompareDiffTableWidget extends StatelessWidget {
  const CompareDiffTableWidget({
    super.key,
    required this.policies,
    required this.diffs,
    required this.insights,
    required this.fields,
    required this.labelWidth,
    required this.columnWidth,
  });

  final List<Policy> policies;
  final Map<String, bool> diffs;
  final CompareInsights insights;
  final List<CompareFieldDefinition> fields;
  final double labelWidth;
  final double columnWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: fields
          .map(
            (field) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: labelWidth,
                    child: Text(
                      field.label,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  ...policies.map(
                    (p) {
                      final isDiff = diffs[field.key] ?? false;
                      final value = field.valueBuilder(p);
                      final bgColor = _cellColor(field.key, p.id, isDiff, context);
                      return Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Container(
                          width: columnWidth,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            value.isNotEmpty ? value : '-',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Color _cellColor(
    String fieldKey,
    String policyId,
    bool isDiff,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    if (insights.nearestDeadlinePolicyId == policyId &&
        (fieldKey == 'application' || fieldKey == 'dday')) {
      return theme.colorScheme.error.withOpacity(0.12);
    }

    if (insights.recommendedPolicyId == policyId) {
      return theme.colorScheme.primary.withOpacity(0.12);
    }

    if (insights.broadEligibilityPolicyId == policyId &&
        fieldKey == 'eligibility') {
      return theme.colorScheme.tertiary.withOpacity(0.12);
    }

    if (isDiff) {
      return Colors.lightBlueAccent.withOpacity(0.08);
    }
    return Colors.grey.withOpacity(0.06);
  }
}
