import 'package:flutter/material.dart';

import '../../../domain/entities/policy.dart';
import 'compare_policy_column_widget.dart';
import '../../models/compare_state.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            '정책 목록',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ...policies.map(
          (p) => Padding(
            padding: const EdgeInsets.only(left: 12),
            child: ComparePolicyColumnWidget(
              policy: p,
              recommendedLabel: insights.recommendedPolicyId == p.id
                  ? '추천 ${insights.recommendedScore}점'
                  : null,
              nearestDeadlineLabel: insights.nearestDeadlinePolicyId == p.id
                  ? _deadlineLabel(insights.nearestDeadlineDays)
                  : null,
              width: columnWidth,
              onRemove: () => onRemove(p.id),
              onTap: () => onOpenDetail(p.id),
            ),
          ),
        ),
      ],
    );
  }

  String _deadlineLabel(int? days) {
    if (days == null) return '마감 임박';
    if (days <= 0) return '오늘 마감';
    return 'D-$days';
  }
}
