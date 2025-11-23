import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/policy.dart';
import 'compare_badge.dart';

class PolicyCardV2 extends ConsumerWidget {
  const PolicyCardV2({
    super.key,
    required this.policy,
    this.onTap,
  });

  final Policy policy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final status = _StatusBadge.fromPolicy(policy);
    final tags = policy.tags.where((t) => t.isNotEmpty).take(2).toList();
    final regionText = (policy.eligibilityRegion == null ||
            policy.eligibilityRegion!.trim().isEmpty)
        ? '지역 전체'
        : policy.eligibilityRegion!;
    final ageText = policy.eligibilityAge == null
        ? '연령 제한 없음'
        : '${policy.eligibilityAge}세 이상';

    final periodText = _formatPeriod(policy.periodStart, policy.periodEnd);
    final ddayText = _formatDday(policy.dday);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderRow(policy: policy, status: status),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _Pill(label: policy.category),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (policy.agency != null &&
                      policy.agency!.trim().isNotEmpty)
                    _InfoRow(icon: '🏢', text: policy.agency!),
                  if (policy.department != null &&
                      policy.department!.trim().isNotEmpty)
                    _InfoRow(icon: '👥', text: policy.department!),
                  _InfoRow(icon: '📍', text: regionText),
                  _InfoRow(icon: '🎯', text: ageText),
                  if (periodText != null)
                    _InfoRow(icon: '📅', text: periodText),
                ],
              ),
              if (tags.isNotEmpty || ddayText != null) ...[
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: tags.isEmpty
                          ? const SizedBox.shrink()
                          : Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: tags
                                  .map(
                                    (tag) => Chip(
                                      label: Text('# $tag'),
                                      backgroundColor:
                                          colorScheme.surfaceVariant,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                    if (ddayText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('⏳'),
                            const SizedBox(width: 4),
                            Text(
                              ddayText,
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? _formatPeriod(String? start, String? end) {
    if ((start == null || start.trim().isEmpty) &&
        (end == null || end.trim().isEmpty)) {
      return null;
    }

    if (start != null && start.trim().isNotEmpty &&
        end != null && end.trim().isNotEmpty) {
      return '$start ~ $end';
    }

    if (start != null && start.trim().isNotEmpty) {
      return '$start 시작';
    }

    return '~ $end';
  }

  String? _formatDday(int? dday) {
    if (dday == null) return null;
    if (dday >= 0) return 'D-$dday';
    return 'D+${dday.abs()}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: colorScheme.onPrimaryContainer),
      ),
    );
  }
}

class _HeaderRow extends ConsumerWidget {
  const _HeaderRow({
    required this.policy,
    required this.status,
  });

  final Policy policy;
  final _StatusBadge? status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(policy.id);

    final compareAsync = ref.watch(compareProvider);
    final isInCompare =
        compareAsync.valueOrNull?.any((p) => p.id == policy.id) ?? false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            policy.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.redAccent : null,
          ),
          onPressed: () =>
              ref.read(favoritesProvider.notifier).toggle(policy.id),
        ),
        CompareBadge(
          child: IconButton(
            icon: Icon(
              isInCompare ? Icons.balance : Icons.balance_outlined,
              color: isInCompare ? Colors.teal : null,
            ),
            onPressed: () =>
                ref.read(compareProvider.notifier).toggle(policy.id),
          ),
        ),
        if (status != null) ...[
          const SizedBox(width: 4),
          status!.toChip(Theme.of(context)),
        ],
      ],
    );
  }
}

class _StatusBadge {
  const _StatusBadge(this.label, this.color);

  final String label;
  final Color color;

  static _StatusBadge? fromPolicy(Policy policy) {
    final now = DateTime.now();
    final start = policy.periodStart != null
        ? DateTime.tryParse(policy.periodStart!)
        : null;

    if (policy.isOngoing == true) {
      return _StatusBadge('모집중', Colors.blue);
    }

    if (policy.isOngoing == false && policy.dday != null && policy.dday! < 0) {
      return _StatusBadge('마감', Colors.grey);
    }

    if (start != null && start.isAfter(now)) {
      return _StatusBadge('예정', Colors.indigo);
    }

    return null;
  }

  Widget toChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
