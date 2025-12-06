import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/policy.dart';
import '../reminder/policy_reminder_badge.dart';

class PolicyCard extends ConsumerWidget {
  const PolicyCard({
    super.key,
    required this.policy,
    required this.onTap,
  });

  final Policy policy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final compareState = ref.watch(compareRepositoryProvider);
    final isCompared = compareState.ids.contains(policy.id);
    final tint = isCompared
        ? Theme.of(context).colorScheme.primary.withOpacity(0.06)
        : null;

    return Card(
      color: tint,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      policy.title,
                      style: textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isCompared) ...[
                    const SizedBox(width: 6),
                    _CompareBadge(),
                  ],
                  const SizedBox(width: 8),
                  PolicyReminderBadge(policyId: policy.id),
                  _FavoriteButton(policy: policy),
                  const SizedBox(width: 4),
                  _CompareButton(policy: policy),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _supportSummary(policy),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${policy.region.name} | ${_targetLabel(policy)}',
                style: textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                _buildPeriodText(policy),
                style: textTheme.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _buildTags(policy)
                    .take(3)
                    .map((t) => _chip(t))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _supportSummary(Policy policy) {
    if (policy.summary.isNotEmpty) return policy.summary;
    return '지원 요약 정보 없음';
  }

  static String _targetLabel(Policy policy) {
    final parts = <String>[];
    if (policy.minAge != null || policy.maxAge != null) {
      final min = policy.minAge != null ? '만 ${policy.minAge}세 이상' : null;
      final max = policy.maxAge != null ? '만 ${policy.maxAge}세 이하' : null;
      final age = [min, max].whereType<String>().join(' / ');
      if (age.isNotEmpty) parts.add(age);
    }
    if (policy.isForYouth) parts.add('청년 대상');
    if (parts.isEmpty) return '대상 정보 없음';
    return parts.join(' · ');
  }

  static Iterable<String> _buildTags(Policy policy) {
    if (policy.tags.isNotEmpty) {
      return policy.tags;
    }
    return [policy.category.name];
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  static String _buildPeriodText(Policy policy) {
    final start = policy.applicationStartDate;
    final end = policy.applicationEndDate;
    if (start == null && end == null) {
      return '일정 미확정';
    }
    if (start != null && end == null) {
      return '신청 시작: ${start.toLocal().toString().split(" ").first}';
    }
    if (start == null && end != null) {
      return '신청 마감: ${end.toLocal().toString().split(" ").first}';
    }
    return '신청 기간: '
        '${start!.toLocal().toString().split(" ").first} ~ '
        '${end!.toLocal().toString().split(" ").first}';
  }
}

class _CompareBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '비교 중',
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoriteIdsProvider);
    final favoriteService = ref.read(policyFavoriteServiceProvider);
    final isFavorite = favoriteIds.contains(policy.id);

    return RepaintBoundary(
      child: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.redAccent : Colors.grey,
        ),
        onPressed: () => favoriteService.toggleFavorite(policy),
      ),
    );
  }
}

class _CompareButton extends ConsumerWidget {
  const _CompareButton({required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareState = ref.watch(compareRepositoryProvider);
    final compareController = ref.read(compareRepositoryProvider.notifier);
    final isCompared = compareState.ids.contains(policy.id);

    final color =
        isCompared ? Theme.of(context).colorScheme.primary : Colors.grey;
    final bg = isCompared ? color.withOpacity(0.12) : Colors.transparent;

    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: Material(
              color: bg,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => compareController.toggleCompare(policy),
                child: Tooltip(
                  message: isCompared ? '비교 해제' : '비교 추가',
                  child: Icon(
                    isCompared
                        ? Icons.compare_arrows
                        : Icons.compare_arrows_outlined,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
          if (isCompared)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '비교 중',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: color, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}
