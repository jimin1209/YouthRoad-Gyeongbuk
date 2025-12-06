import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/filters/policy_filter_ui_state.dart';
import '../../application/providers.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_sort.dart';
import '../compare/widgets/compare_entry_bar.dart';
import '../widgets/policy_feed_list_view.dart';
import '../compare/policy_compare_screen.dart';
import '../../../../ui/layout/app_screen_container.dart';
import '../../../../ui/layout/app_floating_bar.dart';
import '../../../../ui/components/app_card.dart';
import '../../../../ui/components/app_divider.dart';
import '../../../../ui/components/app_section_title.dart';
import '../../../../ui/theme/app_text.dart';
import '../../../../ui/theme/app_spacing.dart';

class PolicyFeedTab extends ConsumerWidget {
  const PolicyFeedTab({
    super.key,
    required this.feedType,
    this.enableSearch = false,
  });

  final PolicyFeedType feedType;
  final bool enableSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(policyFilterUiStateProvider);
    final compareCount = ref.watch(compareRepositoryProvider).ids.length;
    final showCompareBar =
        feedType == PolicyFeedType.favorite && compareCount > 0;

    final summaryText = _buildSummary(filter);
    final showQuickFilter = _hasActiveQuickFilter(filter);

    return Scaffold(
      body: AppScreenContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text('정책 탐색', style: AppText.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              summaryText,
              style: AppText.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.md),
            if (showQuickFilter) ...[
              const AppDivider(),
              const SizedBox(height: AppSpacing.sm),
              const AppSectionTitle(title: '퀵 필터'),
              _QuickFilterBar(
                filter: filter,
                onToggleOngoing: () =>
                    ref.read(policyFilterUiStateProvider.notifier).toggleOngoingOnly(),
                onClearKeyword: () =>
                    ref.read(policyFilterUiStateProvider.notifier).setKeyword(''),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: PolicyFeedListView(feedType: feedType),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
      bottomNavigationBar: showCompareBar
          ? AppFloatingBar(
              height: 56,
              child: CompareEntryBar(
                itemCount: compareCount,
                onOpenCompare: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PolicyCompareScreen(),
                    ),
                  );
                },
              ),
            )
          : null,
    );
  }

  String _buildSummary(PolicyFilterUiState filter) {
    final buffer = StringBuffer();
    buffer.write(filter.regionSummary);
    if (filter.keyword.isNotEmpty) {
      buffer.write(' · "${filter.keyword}"');
    }
    if (filter.category != null) {
      buffer.write(' · ${_categoryLabel(filter.category!)}');
    }
    if (filter.showOnlyOngoing) {
      buffer.write(' · 진행중만');
    }
    switch (filter.sort) {
      case PolicySortOption.recommendation:
        buffer.write(' · 추천순');
        break;
      case PolicySortOption.latest:
        buffer.write(' · 최신순');
        break;
      case PolicySortOption.deadline:
        buffer.write(' · 마감임박');
        break;
      case PolicySortOption.popularity:
        buffer.write(' · 인기순');
        break;
    }
    return buffer.toString();
  }

  bool _hasActiveQuickFilter(PolicyFilterUiState filter) {
    return filter.keyword.isNotEmpty ||
        filter.category != null ||
        filter.showOnlyOngoing ||
        filter.tags.isNotEmpty;
  }

  String _categoryLabel(PolicyCategory category) {
    switch (category) {
      case PolicyCategory.employment:
        return '취업';
      case PolicyCategory.startup:
        return '창업';
      case PolicyCategory.housing:
        return '주거';
      case PolicyCategory.education:
        return '교육';
      case PolicyCategory.life:
        return '생활';
      case PolicyCategory.welfare:
        return '복지';
      case PolicyCategory.culture:
        return '문화';
      case PolicyCategory.other:
        return '기타';
    }
  }
}

class _QuickFilterBar extends StatelessWidget {
  const _QuickFilterBar({
    required this.filter,
    required this.onToggleOngoing,
    required this.onClearKeyword,
  });

  final PolicyFilterUiState filter;
  final VoidCallback onToggleOngoing;
  final VoidCallback onClearKeyword;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      ChoiceChip(
        label: const Text('진행중만'),
        selected: filter.showOnlyOngoing,
        onSelected: (_) => onToggleOngoing(),
      ),
      if (filter.keyword.isNotEmpty)
        ChoiceChip(
          label: Text('검색: ${filter.keyword}'),
          selected: true,
          onSelected: (_) => onClearKeyword(),
        ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 4),
          ...chips.map(
            (c) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: c,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
