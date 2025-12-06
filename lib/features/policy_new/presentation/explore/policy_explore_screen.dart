import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/explore/explore_providers.dart';
import '../../application/explore/explore_state.dart';
import '../../application/filters/policy_filter_ui_state.dart';
import '../../domain/values/policy_feed_type.dart';
import '../filters/policy_filter_bar.dart';
import '../widgets/policy_feed_list_view.dart';
import '../../../../application/notifiers/region_notifier.dart';
import '../../../../ui/screens/region/region_select_screen.dart';

class PolicyExploreScreen extends ConsumerStatefulWidget {
  const PolicyExploreScreen({super.key});

  @override
  ConsumerState<PolicyExploreScreen> createState() => _PolicyExploreScreenState();
}

class _PolicyExploreScreenState extends ConsumerState<PolicyExploreScreen> {
  late final TextEditingController _searchController;

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
    final exploreState = ref.watch(exploreStateProvider);
    final controller = ref.read(exploreStateProvider.notifier);
    final filterUi = ref.watch(policyFilterUiStateProvider);
    final regionNotifier = ref.read(regionProvider.notifier);
    final regionName = exploreState.selectedRegionName ?? regionNotifier.summary;

    if (_searchController.text != exploreState.keyword) {
      _searchController.text = exploreState.keyword;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    }

    final feedType = _feedTypeFor(exploreState);
    final summary = _summaryFor(exploreState, filterUi.regionSummary);

    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 탐색'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하거나 태그를 선택해보세요.',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => controller.setKeyword(_searchController.text),
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onChanged: controller.setKeyword,
                  onTap: () => controller.setMode(ExploreSubMode.search),
                  onSubmitted: controller.setKeyword,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('전체'),
                      selected: exploreState.mode == ExploreSubMode.all &&
                          !exploreState.hasKeyword,
                      onSelected: (_) => controller.setMode(ExploreSubMode.all),
                    ),
                    ChoiceChip(
                      label: Text('내 지역 ($regionName)'),
                      selected: exploreState.mode == ExploreSubMode.region &&
                          exploreState.useMyRegionAsDefault,
                      onSelected: (_) async {
                        await controller.setMyRegion();
                        controller.setMode(ExploreSubMode.region);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('검색'),
                      selected: exploreState.mode == ExploreSubMode.search,
                      onSelected: (_) => controller.setMode(ExploreSubMode.search),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        if (!mounted) return;
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RegionSelectScreen(),
                          ),
                        );
                        final notifier = ref.read(regionProvider.notifier);
                        final city = notifier.selectedCity;
                        final summary = notifier.summary;
                        if (city != null && city.isNotEmpty) {
                          controller.setCustomRegion(name: summary, code: city);
                        } else {
                          controller.setMode(ExploreSubMode.region);
                        }
                      },
                      icon: const Icon(Icons.edit_location_alt_outlined, size: 18),
                      label: const Text('다른 지역 선택'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        summary,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.clearKeyword();
                        controller.clearFilters();
                      },
                      child: const Text('초기화'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _StatusChips(state: exploreState, controller: controller),
            ),
            SliverToBoxAdapter(
              child: _SortMenu(state: exploreState, controller: controller),
            ),
            SliverToBoxAdapter(
              child: _CategoryChips(state: exploreState, controller: controller),
            ),
            const SliverToBoxAdapter(child: PolicyFilterBar()),
            SliverFillRemaining(
              hasScrollBody: true,
              child: _buildBody(
                context: context,
                feedType: feedType,
                exploreState: exploreState,
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
                '검색어를 입력해 주세요.',
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

  String _summaryFor(ExploreState state, String regionSummary) {
    if (state.mode == ExploreSubMode.search && state.keyword.isNotEmpty) {
      return '\"${state.keyword}\" 검색결과';
    }
    if (state.mode == ExploreSubMode.region) {
      final name = state.selectedRegionName?.isNotEmpty == true
          ? state.selectedRegionName!
          : regionSummary;
      return '$name 지역 정책';
    }
    return '경북 전체 정책';
  }
}

class _StatusChips extends StatelessWidget {
  const _StatusChips({
    required this.state,
    required this.controller,
  });

  final ExploreState state;
  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Wrap(
        spacing: 8,
        children: [
          ChoiceChip(
            label: const Text('진행중만'),
            selected: state.statusFilter == PolicyStatusFilter.inProgressOnly,
            onSelected: (_) =>
                controller.setStatusFilter(PolicyStatusFilter.inProgressOnly),
          ),
          ChoiceChip(
            label: const Text('마감 포함'),
            selected: state.statusFilter == PolicyStatusFilter.includeClosed,
            onSelected: (_) =>
                controller.setStatusFilter(PolicyStatusFilter.includeClosed),
          ),
          ChoiceChip(
            label: const Text('마감만'),
            selected: state.statusFilter == PolicyStatusFilter.closedOnly,
            onSelected: (_) =>
                controller.setStatusFilter(PolicyStatusFilter.closedOnly),
          ),
        ],
      ),
    );
  }
}

class _SortMenu extends StatelessWidget {
  const _SortMenu({
    required this.state,
    required this.controller,
  });

  final ExploreState state;
  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: PopupMenuButton<PolicySortKind>(
          initialValue: state.sortKind,
          icon: const Icon(Icons.sort),
          onSelected: controller.setSortKind,
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: PolicySortKind.recommended,
              child: Text('추천순'),
            ),
            PopupMenuItem(
              value: PolicySortKind.newest,
              child: Text('최신 등록순'),
            ),
            PopupMenuItem(
              value: PolicySortKind.deadline,
              child: Text('마감 임박순'),
            ),
            PopupMenuItem(
              value: PolicySortKind.amount,
              child: Text('지원금 많은순'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.state,
    required this.controller,
  });

  final ExploreState state;
  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    final categories = const [
      (id: 'employment', label: '취업'),
      (id: 'startup', label: '창업'),
      (id: 'housing', label: '주거'),
      (id: 'education', label: '교육'),
      (id: 'life', label: '생활지원'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Wrap(
        spacing: 8,
        children: categories.map((c) {
          final selected = state.selectedCategories.contains(c.id);
          return FilterChip(
            label: Text(c.label),
            selected: selected,
            onSelected: (_) => controller.toggleCategory(c.id),
          );
        }).toList(),
      ),
    );
  }
}
