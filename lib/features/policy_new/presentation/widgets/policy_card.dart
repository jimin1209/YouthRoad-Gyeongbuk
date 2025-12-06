import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/entities/policy.dart';
import '../reminder/policy_reminder_badge.dart';

class PolicyCard extends StatelessWidget {
  const PolicyCard({
    super.key,
    required this.policy,
    required this.onTap,
  });

  final Policy policy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      policy.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PolicyReminderBadge(policyId: policy.id),
                  _FavoriteButton(policy: policy),
                  const SizedBox(width: 4),
                  _CompareButton(policy: policy),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                policy.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _chip(policy.region.name),
                  _chip(policy.category.name),
                  if (policy.isOngoing) _chip('모집중'),
                  if (policy.isUpcoming) _chip('시작 예정'),
                  if (policy.isClosed) _chip('마감'),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _buildPeriodText(policy),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
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

  String _buildPeriodText(Policy policy) {
    final start = policy.applicationStartDate;
    final end = policy.applicationEndDate;
    if (start == null && end == null) {
      return '신청 기간 정보 없음';
    }
    if (start != null && end == null) {
      return '신청 시작일: ${start.toLocal().toString().split(" ").first}';
    }
    if (start == null && end != null) {
      return '신청 마감일: ${end.toLocal().toString().split(" ").first}';
    }
    return '신청 기간: '
        '${start!.toLocal().toString().split(" ").first} ~ '
        '${end!.toLocal().toString().split(" ").first}';
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

    final color = isCompared ? Theme.of(context).colorScheme.primary : Colors.grey;
    final bg = isCompared ? color.withOpacity(0.12) : Colors.transparent;

    return RepaintBoundary(
      child: SizedBox(
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
                isCompared ? Icons.compare_arrows : Icons.compare_arrows_outlined,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
