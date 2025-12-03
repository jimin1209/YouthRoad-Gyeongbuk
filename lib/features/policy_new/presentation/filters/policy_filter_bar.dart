import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/filters/policy_filter_ui_state.dart';
import '../../domain/values/policy_sort.dart';
import 'policy_filter_bottom_sheet.dart';
import 'policy_keyword_sheet.dart';
import 'policy_sort_bottom_sheet.dart';

class PolicyFilterBar extends ConsumerWidget {
  const PolicyFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(policyFilterUiStateProvider);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _openKeywordSheet(context),
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
                        ui.keyword.isEmpty ? '검색어를 입력하세요' : ui.keyword,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              ui.keyword.isEmpty ? Colors.grey : Colors.black,
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
            onTap: () => _openSortSheet(context),
          ),
          const SizedBox(width: 6),
          _chipButton(
            context,
            label: '필터',
            icon: Icons.filter_alt_outlined,
            onTap: () => _openFilterSheet(context),
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

  void _openKeywordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const PolicyKeywordSheet(),
    );
  }

  void _openSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const PolicySortBottomSheet(),
    );
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const PolicyFilterBottomSheet(),
    );
  }
}
