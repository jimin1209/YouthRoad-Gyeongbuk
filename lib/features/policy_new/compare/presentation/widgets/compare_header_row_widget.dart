import 'package:flutter/material.dart';

import '../../../domain/entities/policy.dart';
import '../../models/compare_state.dart';
import 'compare_policy_column_widget.dart';

class CompareHeaderRowWidget extends StatelessWidget {
  const CompareHeaderRowWidget({
    super.key,
    required this.policies,
    required this.insights,
    required this.onRemove,
    required this.onOpenDetail,
    required this.labelWidth,
    required this.columnWidth,
  });

  final List<Policy> policies;
  final CompareInsights insights;
  final void Function(String) onRemove;
  final void Function(String) onOpenDetail;
  final double labelWidth;
  final double columnWidth;

  @override
  Widget build(BuildContext context) {
    final totalWidth = labelWidth + (columnWidth + 12) * policies.length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: totalWidth),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: labelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '?曥眳',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '旃措摐毳???晿氅??侅劯毳??搓碃\n脳 氩勴娂?茧 牍勱祼?愳劀 ?滉卑?????堨柎??',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            ...policies.map((policy) {
              final recommendedLabel = insights.recommendedPolicyId == policy.id
                  ? '於旍矞 ${insights.recommendedScore}??'
                  : null;
              final nearestDeadlineLabel =
                  insights.nearestDeadlinePolicyId == policy.id
                      ? _deadlineLabel(insights.nearestDeadlineDays)
                      : null;

              return Padding(
                padding: const EdgeInsets.only(left: 12),
                child: ComparePolicyColumnWidget(
                  policy: policy,
                  onRemove: () => onRemove(policy.id),
                  onTap: () => onOpenDetail(policy.id),
                  width: columnWidth,
                  recommendedLabel: recommendedLabel,
                  nearestDeadlineLabel: nearestDeadlineLabel,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String? _deadlineLabel(int? days) {
    if (days == null) return '毵堦皭 ?勲皶';
    if (days <= 0) return '?る姌 毵堦皭';
    return 'D-$days';
  }
}
