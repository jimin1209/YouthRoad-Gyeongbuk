import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../model/policy_item.dart';
import '../../provider/policy_filter.dart';
import '../../provider/policy_list_provider.dart';
import '../../../../../features/compare/provider/compare_provider.dart';
import '../../../../../features/favorites/provider/favorites_provider.dart';
import '../../../../../features/region/region_model.dart';
import '../../../../../features/region/provider/region_provider.dart';
import '../../../../../features/search/provider/search_history_provider.dart';
import '../card/policy_card_v2.dart';
import '../quick_filter/quick_filter_bar.dart';

class PolicyListPage extends ConsumerStatefulWidget {
  const PolicyListPage({super.key});

  @override
  ConsumerState<PolicyListPage> createState() => _PolicyListPageState();
}

class _PolicyListPageState extends ConsumerState<PolicyListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _applyAble = false;
  String? _selectedYear;
  String _selectedQuick = '전체';
  Region? _lastRegion;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(policyListProvider.notifier).refresh();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(policyListProvider.notifier).fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(policyListProvider);
    final compareList = ref.watch(compareProvider);
    final favorites = ref.watch(favoritesProvider);
    final searchHistory = ref.watch(searchHistoryProvider);
    final region = ref.watch(selectedRegionProvider);

    if (region?.code != _lastRegion?.code) {
      _lastRegion = region;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(policyListProvider.notifier).setRegion(region?.code ?? '');
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('정책 목록')),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => ref.read(policyListProvider.notifier).refresh(),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: QuickFilterPersistentHeader(
                    selected: _selectedQuick,
                    onTap: (label) {
                      setState(() => _selectedQuick = label);
                      ref.read(policyListProvider.notifier).setQuickFilter(label);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildFilters(context, state.filter),
                        const SizedBox(height: 12),
                        if (searchHistory.isNotEmpty) _buildSearchHistory(context, searchHistory),
                      ],
                    ),
                  ),
                ),
                if (state.isLoading && state.items.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  SliverList.builder(
                    itemBuilder: (_, i) {
                      if (i >= state.items.length) return null;
                      final item = state.items[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Dismissible(
                          key: ValueKey(item.id ?? '$i'),
                          background: _swipeBg(context, Alignment.centerLeft, Icons.favorite, '즐겨찾기'),
                          secondaryBackground:
                              _swipeBg(context, Alignment.centerRight, Icons.compare_arrows, '비교함'),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              ref.read(favoritesProvider.notifier).toggle(item.id ?? '');
                            } else {
                              ref.read(compareProvider.notifier).toggle(item);
                            }
                            return false;
                          },
                          child: PolicyCardV2(
                            title: item.title ?? '제목 없음',
                            summary: (item.description ?? '').isEmpty
                                ? '설명 없음'
                                : item.description!.trim(),
                            agency: item.instNm ?? '기관 정보 없음',
                            department: item.deptNm ?? '',
                            policyType: item.policyType ?? '',
                            dDayText: _calcDDay(item.endDate),
                            eligibility: _eligibility(item),
                            isCompared: compareList.any((e) => e.id == item.id),
                            isFavorite: favorites.contains(item.id ?? ''),
                            onTap: () {
                              context.push('/policy/detail/${item.id ?? ''}', extra: item);
                            },
                            onCompareTap: () => ref.read(compareProvider.notifier).toggle(item),
                          ),
                        ),
                      );
                    },
                  ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      if (state.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _bottomCompareBar(context, compareList),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, PolicyFilter filter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: '검색어를 입력하세요',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (value) {
                  ref.read(searchHistoryProvider.notifier).add(value);
                  ref.read(policyListProvider.notifier).setSearchKeyword(value.trim());
                },
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () {
                final kw = _searchController.text.trim();
                ref.read(searchHistoryProvider.notifier).add(kw);
                ref.read(policyListProvider.notifier).setSearchKeyword(kw);
              },
              icon: const Icon(Icons.search),
              label: const Text('검색'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String?>(
                value: _selectedYear,
                decoration: const InputDecoration(
                  labelText: '연도',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: <String?>[null, '2024', '2025', '2026']
                    .map(
                      (year) => DropdownMenuItem<String?>(
                        value: year,
                        child: Text(year ?? '전체'),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() => _selectedYear = v);
                  ref.read(policyListProvider.notifier).setYear(v);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SwitchListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('신청 가능만'),
                value: _applyAble,
                onChanged: (v) {
                  setState(() => _applyAble = v);
                  ref.read(policyListProvider.notifier).toggleApplyAble(v);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchHistory(BuildContext context, List<String> history) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: history
            .map(
              (h) => InputChip(
                label: Text(h),
                onPressed: () {
                  _searchController.text = h;
                  ref.read(policyListProvider.notifier).setSearchKeyword(h);
                },
                onDeleted: () => ref.read(searchHistoryProvider.notifier).remove(h),
              ),
            )
            .toList(),
      ),
    );
  }

  String _calcDDay(String? end) {
    if (end == null || end.isEmpty) return '-';
    try {
      final date = DateTime.parse(end);
      final diff = date.difference(DateTime.now()).inDays;
      return diff.toString();
    } catch (_) {
      return '-';
    }
  }

  EligibilityBadge _eligibility(PolicyItem item) {
    if (item.applyAbleYn == 'Y') return EligibilityBadge.eligible;
    if (item.applyAbleYn == 'N') return EligibilityBadge.notEligible;
    return EligibilityBadge.needCheck;
  }

  Widget _swipeBg(BuildContext context, Alignment alignment, IconData icon, String text) {
    return Container(
      color: alignment == Alignment.centerLeft ? Colors.pinkAccent : Colors.indigo,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _bottomCompareBar(BuildContext context, List compareList) {
    final scheme = Theme.of(context).colorScheme;
    final count = compareList.length;
    if (count == 0) return const SizedBox.shrink();
    final canCompare = count >= 2;
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: scheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.shopping_basket),
            const SizedBox(width: 8),
            Text('비교함 $count/2', style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            if (compareList.isNotEmpty)
              Row(
                children: List.generate(
                  compareList.length,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: scheme.primary.withOpacity(0.2),
                      child: Text('${i + 1}', style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
              ),
            const Spacer(),
            FilledButton(
              onPressed: canCompare
                  ? () => context.push('/policy/compare', extra: compareList.take(2).toList())
                  : null,
              child: const Text('비교하기'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
