import 'package:flutter/material.dart';

import '../../models/compare_state.dart';

class CompareSummaryHighlight extends StatelessWidget {
  const CompareSummaryHighlight({super.key, required this.insights});

  final CompareInsights insights;

  @override
  Widget build(BuildContext context) {
    if (!insights.hasRecommendation &&
        !insights.hasNearestDeadline &&
        !insights.hasEligibilityHighlight) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final chips = <Widget>[];

    if (insights.hasRecommendation) {
      final title = insights.recommendedTitle ?? '추천 정책';
      chips.add(_infoChip(
        context,
        label: '추천 베스트',
        icon: Icons.local_fire_department_outlined,
        description: '$title · ${insights.recommendedScore}점',
        color: theme.colorScheme.primary,
      ));
    }

    if (insights.hasNearestDeadline) {
      final days = insights.nearestDeadlineDays;
      final title = insights.nearestDeadlineTitle ?? '마감 임박 정책';
      final label = days == null
          ? '마감 임박'
          : days <= 0
              ? '신청 마감'
              : 'D-$days 남음';
      chips.add(_infoChip(
        context,
        label: label,
        icon: Icons.timer_outlined,
        description: title,
        color: theme.colorScheme.error,
      ));
    }

    if (insights.hasEligibilityHighlight) {
      chips.add(_infoChip(
        context,
        label: '지원 대상 범위 넓음',
        icon: Icons.public_outlined,
        description: insights.broadEligibilityTitle ?? '지원 대상이 넓은 정책',
        color: theme.colorScheme.tertiary,
      ));
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '비교 하이라이트',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: chips,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String description,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(color: color),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
