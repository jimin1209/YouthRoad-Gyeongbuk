import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/filters/policy_filter_ui_state.dart';
import '../../application/filters/policy_search_keyword_provider.dart';
import '../../application/controllers/global_filter_controller.dart';
import '../../application/controllers/policy_query_state.dart';
import '../../application/providers.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_status_filter.dart';
import '../../application/controllers/policy_query_override.dart';
import '../compare/widgets/compare_entry_bar.dart';
import '../widgets/policy_feed_list_view.dart';
import '../compare/policy_compare_screen.dart';
import '../widgets/policy_query_summary.dart';
import '../../../../ui/layout/app_screen_container.dart';
import '../../../../ui/layout/app_floating_bar.dart';
import '../../../../ui/components/app_card.dart';
import '../../../../ui/components/app_divider.dart';
import '../../../../ui/components/app_section_title.dart';
import '../../../../ui/theme/app_text.dart';
import '../../../../ui/theme/app_spacing.dart';

class PolicyFeedTab extends ConsumerStatefulWidget {
  const PolicyFeedTab({
    super.key,
    required this.feedType,
    this.enableSearch = false,
  });

  final PolicyFeedType feedType;
  final bool enableSearch;

  @override
  ConsumerState<PolicyFeedTab> createState() => _PolicyFeedTabState();
}

class _PolicyFeedTabState extends ConsumerState<PolicyFeedTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.listen<PolicyFilterUiState>(globalFilterProvider,
        (prev, next) async {
      if (!mounted) return;
      if (prev == null || prev == next) return;
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    });

    ref.listen<PolicyQueryState>(
      policyQueryProvider(widget.feedType),
      (_, next) {
        final override =
            ref.read(policyQueryOverrideProvider(widget.feedType));
        if (override == null) return;
        if (override.queryState.hash == next.hash) return;

        Future.microtask(() {
          ref.read(policyQueryOverrideProvider(widget.feedType).notifier)
              .clear();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(globalFilterProvider);
    final keyword = ref.watch(policySearchKeywordProvider(widget.feedType));
    final queryState = ref.watch(policyQueryProvider(widget.feedType));
    final compareCount = ref.watch(compareRepositoryProvider).ids.length;
    final showCompareBar =
        (widget.feedType == PolicyFeedType.favorite ||
                widget.feedType == PolicyFeedType.bookmarked) &&
            compareCount > 0;

    final summaryText = queryState.summary;
    final filterKey = queryState.hash;

    return Scaffold(
      body: AppScreenContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text('정책 탐색', style: AppText.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            PolicyQuerySummary(
              summary: summaryText,
              conditionSummary: queryState.conditionSummary,
              onReset: () =>
                  ref.read(globalFilterControllerProvider).resetAll(),
            ),
            const SizedBox(height: AppSpacing.md),
            _SelectedFilterBadges(
              filter: filter,
              keyword: keyword,
              onClearKeyword: () => ref
                  .read(globalFilterControllerProvider)
                  .setKeyword(widget.feedType, ''),
              onClearCategory: () => ref
                  .read(globalFilterProvider.notifier)
                  .setCategory(null),
              onChangeStatus: (status) => ref
                  .read(globalFilterProvider.notifier)
                  .setStatus(status),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: PolicyFeedListView(
                    key: ValueKey(filterKey),
                    feedType: widget.feedType,
                    externalScrollController: _scrollController,
                  ),
                ),
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

}

class _SelectedFilterBadges extends StatelessWidget {
  const _SelectedFilterBadges({
    required this.filter,
    required this.keyword,
    required this.onClearKeyword,
    required this.onClearCategory,
    required this.onChangeStatus,
  });

  final PolicyFilterUiState filter;
  final String keyword;
  final VoidCallback onClearKeyword;
  final VoidCallback onClearCategory;
  final void Function(PolicyStatusFilter) onChangeStatus;

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[];
    final color = Theme.of(context).colorScheme.primary;
    final textStyle = AppText.textTheme.labelMedium.copyWith(color: color);

    badges.add(_Badge(
      label: filter.regionSummary,
      color: color,
      textStyle: textStyle,
      onRemove: null,
    ));

    if (keyword.isNotEmpty) {
      badges.add(_Badge(
        label: '검색어 "$keyword"',
        color: color,
        textStyle: textStyle,
        onRemove: onClearKeyword,
      ));
    }

    if (filter.category != null) {
      badges.add(_Badge(
        label: _categoryLabel(filter.category!),
        color: color,
        textStyle: textStyle,
        onRemove: onClearCategory,
      ));
    }

    if (filter.status == PolicyStatusFilter.inProgressOnly) {
      badges.add(_Badge(
        label: '진행중 정책만',
        color: color,
        textStyle: textStyle,
        onRemove: () => onChangeStatus(PolicyStatusFilter.includeClosed),
      ));
    } else if (filter.status == PolicyStatusFilter.closedOnly) {
      badges.add(_Badge(
        label: '마감된 정책만',
        color: color,
        textStyle: textStyle,
        onRemove: () => onChangeStatus(PolicyStatusFilter.includeClosed),
      ));
    }

    if (badges.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...badges
              .map((b) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: b,
                  ))
              .toList(),
        ],
      ),
    );
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

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.textStyle,
    this.onRemove,
  });

  final String label;
  final Color color;
  final TextStyle textStyle;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: textStyle),
          if (onRemove != null) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close,
                size: 16,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
