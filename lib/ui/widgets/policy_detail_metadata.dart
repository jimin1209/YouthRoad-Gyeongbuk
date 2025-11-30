import 'package:flutter/material.dart';

import '../../domain/entities/policy.dart';

class PolicyDetailMetadata extends StatelessWidget {
  const PolicyDetailMetadata({super.key, required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badge = _StatusBadge.fromPolicy(policy);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                    '정책 정보',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _OptionalBadge(badge: badge),
              ],
            ),
            const SizedBox(height: 12),
            MetadataRow(
              icon: '🏢',
              label: '주관 기관',
              value: _textOrFallback(policy.supervisorName),
            ),
            MetadataRow(
              icon: '👥',
              label: '운영 기관',
              value: _textOrFallback(policy.operatorName),
            ),
            MetadataRow(
              icon: '📍',
              label: '지역',
              value: _formatRegion(policy.regionName),
            ),
            MetadataRow(
              icon: '📝',
              label: '신청 방법',
              value: _formatApplyMethod(policy.onlineApply),
            ),
            MetadataRow(
              icon: '📄',
              label: '신청 기간',
              value: _formatPeriod(policy.applyStartDate, policy.applyEndDate),
            ),
            MetadataRow(
              icon: '☎️',
              label: '문의',
              value: _textOrFallback(policy.policyEnq),
            ),
            MetadataRow(
              icon: '📅',
              label: '운영 기간',
              value: _formatPeriod(policy.startDate, policy.endDate),
            ),
            MetadataRow(
              icon: '⏳',
              label: '마감까지',
              value: _formatDday(policy.dday),
            ),
            MetadataRow(
              icon: '✅',
              label: '진행 상태',
              value: _formatStatus(policy.isOngoing),
            ),
          ],
        ),
      ),
    );
  }
}

class MetadataRow extends StatelessWidget {
  const MetadataRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionalBadge extends StatelessWidget {
  const _OptionalBadge({super.key, this.badge});

  final _StatusBadge? badge;

  @override
  Widget build(BuildContext context) {
    if (badge == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badge!.color.withOpacity(0.15),
        border: Border.all(color: badge!.color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        badge!.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: badge!.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _StatusBadge {
  const _StatusBadge(this.label, this.color);

  final String label;
  final Color color;

  static _StatusBadge? fromPolicy(Policy policy) {
    final now = DateTime.now();
    final start = policy.startDate;
    final end = policy.endDate;

    if (policy.isOngoing == true) {
      return const _StatusBadge('모집중', Colors.blue);
    }

    if (policy.isOngoing == false && policy.dday != null && policy.dday! < 0) {
      return const _StatusBadge('마감', Colors.grey);
    }

    if (end != null && end.isBefore(now)) {
      return const _StatusBadge('마감', Colors.grey);
    }

    if (start != null && start.isAfter(now)) {
      return const _StatusBadge('예정', Colors.indigo);
    }

    return null;
  }
}

String _textOrFallback(String? value, {String fallback = '정보 없음'}) {
  final text = value?.trim();
  if (text == null || text.isEmpty) return fallback;
  return text;
}

String _formatRegion(String? region) {
  if (region == null || region.trim().isEmpty) return '지역 전체';
  return region;
}

String _formatPeriod(DateTime? start, DateTime? end) {
  final startText = _formatDate(start);
  final endText = _formatDate(end);
  final hasStart = startText.isNotEmpty;
  final hasEnd = endText.isNotEmpty;

  if (!hasStart && !hasEnd) return '정보 없음';
  if (hasStart && hasEnd) return '$startText ~ $endText';
  if (hasStart) return '$startText 시작';
  return '~ $endText';
}

String _formatDday(int? dday) {
  if (dday == null) return '정보 없음';
  if (dday >= 0) return 'D-$dday';
  return 'D+${dday.abs()}';
}

String _formatStatus(bool? isOngoing) {
  if (isOngoing == null) return '정보 없음';
  return isOngoing ? '진행 중' : '진행 종료';
}

String _formatDate(DateTime? date) {
  if (date == null) return '';
  return date.toIso8601String().split('T').first;
}

String _formatApplyMethod(bool? onlineApply) {
  if (onlineApply == null) return '기관 문의 필요';
  return onlineApply ? '온라인 신청 가능' : '기관 문의 필요';
}
