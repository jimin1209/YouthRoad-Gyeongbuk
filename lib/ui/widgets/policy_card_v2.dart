import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/policy.dart';
import 'compare_badge.dart';

List<String> getPolicyTags(Policy policy) {
  return policy.tags.where((tag) => tag.trim().isNotEmpty).toList();
}

Widget buildTagChips(BuildContext context, List<String> tags) {
  if (tags.isEmpty) return const SizedBox.shrink();

  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Wrap(
    spacing: 6,
    runSpacing: 4,
    children: tags
        .map(
          (tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tag,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        )
        .toList(),
  );
}

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
    final tags = getPolicyTags(policy);
    final regionText = (policy.rgnSeNm == null || policy.rgnSeNm!.trim().isEmpty)
        ? '지역 전체'
        : policy.rgnSeNm!.trim();
    final ageText = _buildAgeText(policy);

    final periodText = _formatPeriod(policy.policyBgngYmd, policy.policyEndYmd);
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
              if (tags.isNotEmpty) ...[
                const SizedBox(height: 4),
                buildTagChips(context, tags),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _Pill(label: policy.policyTypeNm ?? '정책'),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (policy.sprvsnInstNm != null &&
                      policy.sprvsnInstNm!.trim().isNotEmpty)
                    _InfoRow(icon: '🏢', text: policy.sprvsnInstNm!),
                  if (policy.operInstNm != null &&
                      policy.operInstNm!.trim().isNotEmpty)
                    _InfoRow(icon: '👥', text: policy.operInstNm!),
                  _InfoRow(icon: '📍', text: regionText),
                  _InfoRow(icon: '🎯', text: ageText),
                  if (periodText != null)
                    _InfoRow(icon: '📅', text: periodText),
                ],
              ),
              if (ddayText != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
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
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? _formatPeriod(DateTime? start, DateTime? end) {
    final startText = _formatDate(start);
    final endText = _formatDate(end);
    final hasStart = startText != null && startText.isNotEmpty;
    final hasEnd = endText != null && endText.isNotEmpty;

    if (!hasStart && !hasEnd) {
      return null;
    }
    if (hasStart && hasEnd) {
      return '$startText ~ $endText';
    }
    if (hasStart) {
      return '$startText 시작';
    }
    return '~ $endText';
  }

  String? _formatDday(int? dday) {
    if (dday == null) return null;
    if (dday == 0) return 'D-Day';
    if (dday >= 0) return 'D-$dday';
    return 'D+${dday.abs()}';
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return date.toIso8601String().split('T').first;
  }

  String _buildAgeText(Policy policy) {
    final candidates = [policy.policyScl, policy.policyCn];
    final rangePattern = RegExp(r'(만\s*)?\d{1,2}\s*~\s*\d{1,2}\s*세');
    final singlePattern = RegExp(r'(만\s*)?\d{1,2}\s*세');

    for (final text in candidates) {
      if (text == null) continue;
      final rangeMatch = rangePattern.firstMatch(text);
      if (rangeMatch != null) {
        return rangeMatch.group(0)!.replaceAll(RegExp(r'\s+'), ' ').trim();
      }
      final singleMatch = singlePattern.firstMatch(text);
      if (singleMatch != null) {
        return singleMatch.group(0)!.replaceAll(RegExp(r'\s+'), ' ').trim();
      }
    }

    return '연령 정보 없음';
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

  static const double _actionSize = 40;

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
        /// 정책명 영역 → 무조건 Expanded 적용하여 overflow 방지
        Expanded(
          child: Text(
            policy.policyNm,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),

        const SizedBox(width: 4),

        /// 즐겨찾기 버튼
        SizedBox(
          width: _actionSize,
          height: _actionSize,
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.redAccent : null,
            ),
            onPressed: () =>
                ref.read(favoritesProvider.notifier).toggle(policy.id),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ),

        /// 비교 버튼
        CompareBadge(
          child: SizedBox(
            width: _actionSize,
            height: _actionSize,
            child: IconButton(
              icon: Icon(
                isInCompare ? Icons.balance : Icons.balance_outlined,
                color: isInCompare ? Colors.teal : null,
              ),
              onPressed: () =>
                  ref.read(compareProvider.notifier).toggle(policy.id),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),

        /// 상태 뱃지
        if (status != null) ...[
          const SizedBox(width: 4),
          Flexible(child: status!.toChip(Theme.of(context))),
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
    final start = policy.policyBgngYmd;
    final end = policy.policyEndYmd;

    if (policy.isOngoing == true) {
      return _StatusBadge('모집중', Colors.blue);
    }

    if (policy.isOngoing == false && policy.dday != null && policy.dday! < 0) {
      return _StatusBadge('마감', Colors.grey);
    }

    if (end != null && end.isBefore(now)) {
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
