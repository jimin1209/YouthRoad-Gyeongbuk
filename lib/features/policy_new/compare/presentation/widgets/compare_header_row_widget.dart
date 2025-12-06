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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: labelWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '정책',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '카드를 탭하면 상세를 열고\n× 버튼으로 비교에서 제거할 수 있어요.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        ...policies.map((policy) {
          final recommendedLabel = insights.recommendedPolicyId == policy.id
              ? '추천 ${insights.recommendedScore}점'
              : null;
          final nearestDeadlineLabel = insights.nearestDeadlinePolicyId == policy.id
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
    );
  }

  String? _deadlineLabel(int? days) {
    if (days == null) return '마감 임박';
    if (days <= 0) return '오늘 마감';
    return 'D-$days';
  }
}
