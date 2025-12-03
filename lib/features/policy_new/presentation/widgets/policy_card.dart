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
  Widget build(BuildContext context, WidgetRef _ref) {
    final favoriteState = _ref.watch(favoriteRepositoryProvider);
    final compareState = _ref.watch(compareRepositoryProvider);
    final favoriteController = _ref.read(favoriteRepositoryProvider.notifier);
    final compareController = _ref.read(compareRepositoryProvider.notifier);

    final isFavorite = favoriteState.allIds.contains(policy.id);
    final isCompared = compareState.ids.contains(policy.id);

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
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.redAccent : Colors.grey,
                    ),
                    onPressed: () => favoriteController.toggleFavorite(policy),
                  ),
                  IconButton(
                    icon: Icon(
                      isCompared
                          ? Icons.compare_arrows
                          : Icons.compare_arrows_outlined,
                      color: isCompared ? Colors.blueAccent : Colors.grey,
                    ),
                    onPressed: () => compareController.toggleCompare(policy),
                  ),
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
