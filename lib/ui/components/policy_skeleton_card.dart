import 'package:flutter/material.dart';
import 'package:youth_road_app/theme/app_theme.dart';

class PolicySkeletonCard extends StatelessWidget {
  const PolicySkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final policyTheme = Theme.of(context).extension<PolicyTheme>()!;

    Widget bar(double w, double h) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: scheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
        );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(policyTheme.policyCardRadius),
      ),
      child: Padding(
        padding: policyTheme.policyCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bar(180, 18),
            const SizedBox(height: 10),
            bar(double.infinity, 14),
            const SizedBox(height: 6),
            bar(double.infinity, 14),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                bar(50, 20),
                bar(60, 20),
                bar(40, 20),
              ],
            ),
            const SizedBox(height: 16),
            bar(120, 12),
          ],
        ),
      ),
    );
  }
}
