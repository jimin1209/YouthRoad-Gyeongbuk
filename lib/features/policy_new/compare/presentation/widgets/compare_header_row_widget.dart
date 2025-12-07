import 'package:flutter/material.dart';

import '../../../domain/entities/policy.dart';
import '../../models/compare_state.dart';
import 'compare_policy_column_widget.dart';
import '../../../../../ui/components/horizontal_overflow_container.dart';

class CompareHeaderRowWidget extends StatelessWidget {
  const CompareHeaderRowWidget({
    super.key,
    required this.policies,
    required this.insights,
    required this.onRemove,
    required this.onOpenDetail,
    required this.labelWidth,
    required this.columnWidth,
    this.overflowController,
  });

  final List<Policy> policies;
  final CompareInsights insights;
  final void Function(String) onRemove;
  final void Function(String) onOpenDetail;
  final double labelWidth;
  final double columnWidth;
  final HorizontalOverflowController? overflowController;

  @override
  Widget build(BuildContext context) {
    final totalWidth = labelWidth + (columnWidth + 12) * policies.length;

    return HorizontalOverflowContainer(
      controller: overflowController,
      minWidth: totalWidth,
      children: [
        SizedBox(
          width: labelWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '비교 요약',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '가로 스크롤로 정책을 비교하세요.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        ...policies.map((policy) {
          final recommendedLabel = insights.recommendedPolicyId == policy.id
              ? '추천 ${insights.recommendedScore}점'
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
    );
  }

  String? _deadlineLabel(int? days) {
    if (days == null) return '마감 정보 없음';
    if (days <= 0) return '신청 마감';
    return 'D-$days';
  }
}
