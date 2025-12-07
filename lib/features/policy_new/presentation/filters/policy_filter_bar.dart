import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/controllers/ui_reaction_controller.dart';
import '../../application/filters/policy_filter_ui_state.dart';
import '../../application/filters/policy_search_keyword_provider.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_sort.dart';
import '../../../../ui/components/horizontal_overflow_container.dart';
import 'policy_filter_bottom_sheet.dart';
import 'policy_keyword_sheet.dart';
import 'policy_sort_bottom_sheet.dart';

class PolicyFilterBar extends ConsumerWidget {
  const PolicyFilterBar({
    super.key,
    this.feedType = PolicyFeedType.recommend,
  });

  final PolicyFeedType feedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(globalFilterProvider);
    final keyword = ref.watch(policySearchKeywordProvider(feedType));

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: HorizontalOverflowContainer(
        minWidthPerChild: 180,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 220, maxWidth: 360),
            child: GestureDetector(
              onTap: () => _openKeywordSheet(context, ref),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        keyword.isEmpty ? '검색어를 입력하세요' : keyword,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: keyword.isEmpty ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _chipButton(
            context,
            label: _sortLabel(ui.sort),
            icon: Icons.swap_vert,
            onTap: () => _openSortSheet(context, ref),
          ),
          const SizedBox(width: 6),
          _chipButton(
            context,
            label: '필터',
            icon: Icons.filter_alt_outlined,
            onTap: () => _openFilterSheet(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _chipButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  String _sortLabel(PolicySortOption sort) {
    switch (sort) {
      case PolicySortOption.latest:
        return '최신순';
      case PolicySortOption.deadline:
        return '마감 임박';
      case PolicySortOption.popularity:
        return '인기순';
      case PolicySortOption.recommendation:
        return '추천순';
    }
  }

  void _openKeywordSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => PolicyKeywordSheet(feedType: feedType),
    );
    ref
        .read(uiReactionControllerProvider(feedType).notifier)
        .markSearchConfirmed(ref.read(policySearchKeywordProvider(feedType)));
  }

  void _openSortSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => PolicySortBottomSheet(feedType: feedType),
    );
    ref
        .read(uiReactionControllerProvider(feedType).notifier)
        .markFilterConfirmed('정렬 순서를 적용했어요.');
  }

  void _openFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => PolicyFilterBottomSheet(feedType: feedType),
    );
    ref
        .read(uiReactionControllerProvider(feedType).notifier)
        .markFilterConfirmed('필터를 적용했어요.');
  }
}
