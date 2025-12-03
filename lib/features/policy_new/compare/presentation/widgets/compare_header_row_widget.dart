import 'package:flutter/material.dart';

import '../../../domain/entities/policy.dart';
import 'compare_policy_column_widget.dart';

class CompareHeaderRowWidget extends StatelessWidget {
  const CompareHeaderRowWidget({
    super.key,
    required this.policies,
    required this.onRemove,
    required this.onOpenDetail,
    required this.labelWidth,
    required this.columnWidth,
  });

  final List<Policy> policies;
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
              width: columnWidth,
              onRemove: () => onRemove(p.id),
              onTap: () => onOpenDetail(p.id),
            ),
          ),
        ),
      ],
    );
  }
}
