import 'package:flutter/material.dart';

enum EligibilityBadge { eligible, needCheck, notEligible }

class PolicyCardV2 extends StatelessWidget {
  const PolicyCardV2({
    super.key,
    required this.title,
    required this.summary,
    required this.agency,
    required this.department,
    required this.policyType,
    required this.dDayText,
    this.eligibility = EligibilityBadge.needCheck,
    this.onTap,
    this.onCompareTap,
    this.isCompared = false,
    this.isFavorite = false,
  });

  final String title;
  final String summary;
  final String agency;
  final String department;
  final String policyType;
  final String dDayText;
  final EligibilityBadge eligibility;
  final VoidCallback? onTap;
  final VoidCallback? onCompareTap;
  final bool isCompared;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final (Color bg, String text, Color fg) = switch (eligibility) {
      EligibilityBadge.eligible =>
        (scheme.primary.withOpacity(0.12), 'Eligible', scheme.primary),
      EligibilityBadge.needCheck =>
        (scheme.tertiary.withOpacity(0.12), 'Need Check', scheme.tertiary),
      EligibilityBadge.notEligible =>
        (scheme.error.withOpacity(0.12), 'Not Eligible', scheme.error),
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
                  child: Text(text, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg)),
                ),
                const Spacer(),
                _ddayLabel(context, dDayText),
              ],
            ),
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(summary, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _tag(context, policyType, scheme.primary),
                _tag(context, agency, scheme.secondary),
                _tag(context, department, scheme.tertiary),
                if (dDayText != '-') _tag(context, 'D-$dDayText', _ddayColor(scheme, dDayText)),
                if (isFavorite) _tag(context, '즐겨찾기', scheme.primary),
                _tag(context, '조회수 TOP10', scheme.outline),
              ],
            ),
            if (onCompareTap != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onCompareTap,
                icon: Icon(Icons.compare, color: isCompared ? scheme.primary : null),
                label: Text(isCompared ? '비교함 담김' : '비교함 담기'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _ddayLabel(BuildContext context, String dDayText) {
    final scheme = Theme.of(context).colorScheme;
    final color = _ddayColor(scheme, dDayText);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('D-$dDayText', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
    );
  }

  Color _ddayColor(ColorScheme scheme, String dDayText) {
    final int? days = int.tryParse(dDayText);
    if (days == null) return scheme.primary;
    if (days <= 7) return Colors.red;
    if (days <= 30) return Colors.orange;
    if (days <= 90) return scheme.primary;
    return scheme.outline;
  }

  Widget _tag(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
