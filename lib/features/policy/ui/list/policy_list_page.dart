import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../model/policy_item.dart';
import '../../provider/policy_filter.dart';
import '../../provider/policy_list_provider.dart';
import '../../../../../features/compare/provider/compare_provider.dart';
import '../../../../../features/policy_compare/ui/compare_fab.dart';
import 'package:youth_road_app/feature/region/region_provider.dart';
import 'package:youth_road_app/feature/region/region_model.dart';
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
      // 기본 전체 목록 자동 로드
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
    final region = ref.watch(selectedRegionProvider);
    if (region?.code != _lastRegion?.code) {
      _lastRegion = region;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(policyListProvider.notifier).setRegion(region?.code ?? '');
      });
    }
    return Scaffold(
      appBar: AppBar(title: const Text('정책 목록')),
      floatingActionButton: compareList.isNotEmpty
          ? CompareFab(
              count: compareList.length,
              onTap: () {
                if (compareList.length >= 2) {
                  context.push('/policy/compare', extra: compareList.take(2).toList());
                }
              },
            )
          : null,
      body: RefreshIndicator(
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
                child: _buildFilters(context, state.filter),
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
                      onTap: () {
                        // 라우팅 연결 시 사용
                      },
                      isCompared: compareList.any((e) => e.id == item.id),
                      onCompareTap: () => ref.read(compareProvider.notifier).toggle(item),
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
                  if (compareList.length >= 2)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Material(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => context.push('/policy/compare', extra: compareList.take(2).toList()),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('비교함에 ${compareList.length}개 담김', style: Theme.of(context).textTheme.bodyMedium),
                                const Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
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
                onSubmitted: (value) => ref
                    .read(policyListProvider.notifier)
                    .setSearchKeyword(value.trim()),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => ref
                  .read(policyListProvider.notifier)
                  .setSearchKeyword(_searchController.text.trim()),
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

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
