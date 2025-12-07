// lib/features/policy_new/presentation/explore/policy_explore_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/explore/explore_providers.dart';
import '../../application/explore/explore_state.dart';
import '../../application/filters/policy_filter_ui_state.dart';
import '../../application/providers.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_sort.dart';
import '../filters/policy_filter_bar.dart';
import '../widgets/policy_feed_list_view.dart';
import '../../../../application/notifiers/region_notifier.dart';
import '../../../../ui/screens/region/region_select_screen.dart';

class PolicyExploreScreen extends ConsumerStatefulWidget {
  const PolicyExploreScreen({super.key});

  @override
  ConsumerState<PolicyExploreScreen> createState() =>
      _PolicyExploreScreenState();
}

class _PolicyExploreScreenState extends ConsumerState<PolicyExploreScreen> {
  late final TextEditingController _searchController;

  static const _categories = [
    (id: 'employment', label: '취업'),
    (id: 'startup', label: '창업'),
    (id: 'housing', label: '주거'),
    (id: 'education', label: '교육'),
    (id: 'life', label: '생활'),
  ];

  @override
  void initState() {
    super.initState();
    final state = ref.read(exploreStateProvider);
    _searchController = TextEditingController(text: state.keyword);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exploreStateProvider);
    final controller = ref.read(exploreStateProvider.notifier);
    final filterUi = ref.watch(policyFilterUiStateProvider);
    final regionNotifier = ref.read(regionProvider.notifier);
    final regionName = state.selectedRegionName ?? regionNotifier.summary;

    // 검색어 동기화
    if (_searchController.text != state.keyword) {
      _searchController.text = state.keyword;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    }

    final feedType = _feedTypeFor(state);
    final queryState = ref.watch(policyQueryProvider(feedType));
    final summary = queryState.summary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 탐색'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔹 상단 컨트롤 영역 (검색 / 퀵 필터 / 요약)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SearchBarRow(
                    keyword: state.keyword,
                    sortKind: state.sortKind,
                    onKeywordChanged: controller.setKeyword,
                    onSubmit: controller.setKeyword,
                    onSortChanged: controller.setSortKind,
                    onOpenFilterSheet: () =>
                        _openFilterBottomSheet(context, controller, state),
                    textController: _searchController,
                  ),
                  const SizedBox(height: 8),
                  _QuickFilterChips(
                    state: state,
                    regionName: regionName,
                    onToggleStatus: (value) =>
                        controller.setStatusFilter(value),
                    onToggleRegion: () {
                      final isRegion = state.mode == ExploreSubMode.region;
                      if (isRegion) {
                        controller.setMode(ExploreSubMode.all);
                      } else {
                        controller.setMode(ExploreSubMode.region);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    summary: summary,
                    conditionSummary: queryState.conditionSummary,
                    onReset: controller.clearFilters,
                    onTap: () =>
                        _openFilterBottomSheet(context, controller, state),
                  ),
                ],
              ),
            ),

            // 🔹 탐색 상단 공통 필터 바
            PolicyFilterBar(feedType: feedType),

            // 🔹 본문: 정책 리스트 (단일 스크롤)
            Expanded(
              child: _buildBody(
                context: context,
                feedType: feedType,
                exploreState: state,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required PolicyFeedType feedType,
    required ExploreState exploreState,
  }) {
    if (exploreState.mode == ExploreSubMode.search &&
        exploreState.keyword.trim().isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '검색어를 입력해 주세요',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('예) 취업, 창업, 주거'),
            ],
          ),
        ),
      );
    }

    return PolicyFeedListView(feedType: feedType);
  }

  PolicyFeedType _feedTypeFor(ExploreState state) {
    if (state.mode == ExploreSubMode.search && state.keyword.isNotEmpty) {
      return PolicyFeedType.search;
    }
    if (state.mode == ExploreSubMode.region) {
      return PolicyFeedType.region;
    }
    return PolicyFeedType.all;
  }

  void _openFilterBottomSheet(
    BuildContext context,
    ExploreController controller,
    ExploreState state,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final tempCategories = {...state.selectedCategories};
        var tempStatus = state.statusFilter;
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '필터',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              tempCategories.clear();
                              tempStatus = PolicyStatusFilter.inProgressOnly;
                            });
                          },
                          child: const Text('초기화'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '진행 상태',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _statusChip(
                          label: '진행중만',
                          selected:
                              tempStatus == PolicyStatusFilter.inProgressOnly,
                          onTap: () => setState(
                            () =>
                                tempStatus = PolicyStatusFilter.inProgressOnly,
                          ),
                        ),
                        _statusChip(
                          label: '마감 포함',
                          selected:
                              tempStatus == PolicyStatusFilter.includeClosed,
                          onTap: () => setState(
                            () => tempStatus = PolicyStatusFilter.includeClosed,
                          ),
                        ),
                        _statusChip(
                          label: '마감만',
                          selected: tempStatus == PolicyStatusFilter.closedOnly,
                          onTap: () => setState(
                            () => tempStatus = PolicyStatusFilter.closedOnly,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '카테고리',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: _categories
                          .map(
                            (c) => FilterChip(
                              label: Text(c.label),
                              selected: tempCategories.contains(c.id),
                              onSelected: (_) {
                                setState(() {
                                  if (tempCategories.contains(c.id)) {
                                    tempCategories.remove(c.id);
                                  } else {
                                    tempCategories.add(c.id);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('닫기'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.clearFilters();
                              controller.setStatusFilter(tempStatus);
                              for (final id in tempCategories) {
                                controller.toggleCategory(id);
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text('적용'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _statusChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _SearchBarRow extends StatelessWidget {
  const _SearchBarRow({
    required this.keyword,
    required this.sortKind,
    required this.onKeywordChanged,
    required this.onSubmit,
    required this.onSortChanged,
    required this.onOpenFilterSheet,
    required this.textController,
  });

  final String keyword;
  final PolicySortKind sortKind;
  final void Function(String) onKeywordChanged;
  final void Function(String) onSubmit;
  final void Function(PolicySortKind) onSortChanged;
  final VoidCallback onOpenFilterSheet;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    if (textController.text != keyword) {
      textController.text = keyword;
      textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length),
      );
    }

    final sortLabel = _sortLabel(sortKind);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: '검색어를 입력하세요',
            ),
            textInputAction: TextInputAction.search,
            onChanged: onKeywordChanged,
            onSubmitted: onSubmit,
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<PolicySortKind>(
          tooltip: '정렬',
          initialValue: sortKind,
          onSelected: onSortChanged,
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: PolicySortKind.recommended,
              child: Text('추천순'),
            ),
            PopupMenuItem(
              value: PolicySortKind.newest,
              child: Text('최신순'),
            ),
            PopupMenuItem(
              value: PolicySortKind.deadline,
              child: Text('마감임박'),
            ),
            PopupMenuItem(
              value: PolicySortKind.amount,
              child: Text('인기순'),
            ),
          ],
          // 🔵 OutlinedButton.icon 대신, 폭 제약이 안전한 커스텀 뷰
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sort, size: 18),
                const SizedBox(width: 4),
                Text(
                  sortLabel,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        IconButton(
          tooltip: '필터',
          onPressed: onOpenFilterSheet,
          icon: const Icon(Icons.filter_alt),
        ),
      ],
    );
  }

  String _sortLabel(PolicySortKind kind) {
    switch (kind) {
      case PolicySortKind.recommended:
        return '추천순';
      case PolicySortKind.newest:
        return '최신순';
      case PolicySortKind.deadline:
        return '마감임박';
      case PolicySortKind.amount:
        return '인기순';
    }
  }
}

class _QuickFilterChips extends StatelessWidget {
  const _QuickFilterChips({
    required this.state,
    required this.regionName,
    required this.onToggleStatus,
    required this.onToggleRegion,
  });

  final ExploreState state;
  final String regionName;
  final void Function(PolicyStatusFilter) onToggleStatus;
  final VoidCallback onToggleRegion;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      ChoiceChip(
        label: const Text('진행중만'),
        selected: state.statusFilter == PolicyStatusFilter.inProgressOnly,
        onSelected: (_) => onToggleStatus(PolicyStatusFilter.inProgressOnly),
      ),
      ChoiceChip(
        label: Text('내 지역 ($regionName)'),
        selected: state.mode == ExploreSubMode.region,
        onSelected: (_) => onToggleRegion(),
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
              child: c,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.summary,
    required this.conditionSummary,
    required this.onReset,
    required this.onTap,
  });

  final String summary;
  final String conditionSummary;
  final VoidCallback onReset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  conditionSummary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onReset,
            child: const Text('초기화'),
          ),
        ],
      ),
    );
  }
}
