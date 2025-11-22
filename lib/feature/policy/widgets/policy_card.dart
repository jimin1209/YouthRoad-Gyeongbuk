import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../data/model/policy_models.dart';

class PolicyCard extends StatelessWidget {
  const PolicyCard({
    super.key,
    required this.policy,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  final PolicyItem policy;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    policy.policyNm ?? '제목 없음',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? scheme.primary : scheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _Tag(
                  text: policy.policyTypeNm ?? '유형 미정',
                  background: scheme.primary.withOpacity(0.12),
                  color: scheme.primary,
                ),
                _Tag(
                  text: policy.rgnSeNm ?? '지역 미정',
                  background: scheme.secondary.withOpacity(0.12),
                  color: scheme.secondary,
                ),
                _Tag(
                  text: policy.aplyPsbltyYn == 'Y' ? '신청 가능' : '신청 불가',
                  background: (policy.aplyPsbltyYn == 'Y'
                          ? scheme.tertiary
                          : scheme.error)
                      .withOpacity(0.12),
                  color: policy.aplyPsbltyYn == 'Y' ? scheme.tertiary : scheme.error,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${policy.sprvsnInstNm ?? ''} / ${policy.operInstNm ?? ''}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              formatDateRange(policy.policyBgngYmd, policy.policyEndYmd),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.text,
    required this.background,
    required this.color,
  });

  final String text;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
      ),
    );
  }
}
