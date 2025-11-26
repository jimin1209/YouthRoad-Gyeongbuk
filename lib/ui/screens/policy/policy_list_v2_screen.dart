import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/notifiers/policy_paging_notifier.dart';
import '../../../application/providers.dart';
import '../../../data/models/policy_filter.dart';
import '../../../data/sources/local/search_history_source.dart';
import '../../../navigation/route_paths.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/global_error_view.dart';
import '../../widgets/policy_card_v2.dart';

class PolicyListV2Screen extends ConsumerStatefulWidget {
  const PolicyListV2Screen({super.key});

  @override
  ConsumerState<PolicyListV2Screen> createState() => _PolicyListV2ScreenState();
}

class _PolicyListV2ScreenState extends ConsumerState<PolicyListV2Screen> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;
  late final ProviderSubscription<String?> _regionSubscription;
  String? _selectedCategory;
  String? _selectedYear;
  bool _availableOnly = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _regionSubscription = ref.listenManual<String?>(regionProvider, (prev, next) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyFilterDebounced();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(policyPagingProvider.notifier).loadInitial(_buildFilter());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _regionSubscription.close();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = ref.read(policyPagingProvider);
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(policyPagingProvider.notifier).loadMore();
    }
  }

  PolicyFilter _buildFilter() {
    final region = ref.read(regionProvider);
    return PolicyFilter(
      searchRgnSe: region,
      searchPolicyNm: _controller.text.trim().isEmpty ? null : _controller.text.trim(),
      category: _selectedCategory,
      searchYear: _selectedYear,
      availableOnly: _availableOnly,
      pageIndex: 1,
      recordCount: 10,
      pagingYn: 'Y',
    );
  }

  void _applyFilter() {
    ref.read(policyPagingProvider.notifier).updateFilter(_buildFilter());
  }

  void _applyFilterDebounced() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), _applyFilter);
  }

  Future<void> _performSearch(PolicyPagingNotifier notifier) async {
    _applyFilterDebounced();
  }

  @override
  Widget build(BuildContext context) {
    final pagingState = ref.watch(policyPagingProvider);
    final pagingNotifier = ref.read(policyPagingProvider.notifier);
    final history = ref.watch(searchHistoryListProvider);
    final compareCount = ref.watch(
      compareProvider.select((value) => value.valueOrNull?.length ?? 0),
    );

    Widget buildList() {
      if (pagingState.error != null && pagingState.items.isEmpty) {
        return GlobalErrorView(
          message: pagingState.error!,
          onRetry: () => pagingNotifier.loadInitial(_buildFilter()),
        );
      }

      if (pagingState.items.isEmpty && pagingState.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (pagingState.items.isEmpty) {
        return GlobalErrorView(
          message: '표시할 정책이 없습니다.',
          onRetry: () => pagingNotifier.loadInitial(_buildFilter()),
        );
      }

      return RefreshIndicator(
        onRefresh: () => pagingNotifier.loadInitial(_buildFilter()),
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemBuilder: (_, i) {
            if (i >= pagingState.items.length) {
              if (!pagingState.hasMore) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('마지막 정책까지 모두 불러왔습니다.')),
                );
              }
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final policy = pagingState.items[i];
            return PolicyCardV2(
              policy: policy,
              onTap: () => context.push(RoutePaths.policyDetail(policy.id)),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount:
              pagingState.items.length + (pagingState.isLoadingMore || pagingState.hasMore ? 1 : 0),
        ),
      );
    }

    Widget buildHistory() {
      return history.when(
        data: (list) {
          if (list.isEmpty) return const SizedBox.shrink();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: list
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(e.query),
                        onPressed: () {
                          _controller.text = e.query;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _applyFilterDebounced();
                          });
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      );
    }

    return Scaffold(
      appBar: const AppAppBar(title: '정책 목록'),
      floatingActionButton: compareCount == 0
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(RoutePaths.compare),
              icon: const Icon(Icons.balance),
              label: Text('비교하기 ($compareCount)'),
            ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '정책명을 입력하세요',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _performSearch(pagingNotifier),
                ),
              ),
              onSubmitted: (_) => _performSearch(pagingNotifier),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('전체'),
                        selected: _selectedCategory == null,
                        onSelected: (_) {
                          setState(() => _selectedCategory = null);
                          _applyFilterDebounced();
                        },
                      ),
                      ChoiceChip(
                        label: const Text('취업'),
                        selected: _selectedCategory == '취업',
                        onSelected: (_) {
                          setState(() => _selectedCategory = '취업');
                          _applyFilterDebounced();
                        },
                      ),
                      ChoiceChip(
                        label: const Text('창업'),
                        selected: _selectedCategory == '창업',
                        onSelected: (_) {
                          setState(() => _selectedCategory = '창업');
                          _applyFilterDebounced();
                        },
                      ),
                    ],
                  ),
                ),
                DropdownButton<String?>(
                  value: _selectedYear,
                  hint: const Text('연도'),
                  items: const [null, '2024', '2023']
                      .map(
                        (e) => DropdownMenuItem<String?>(
                          value: e,
                          child: Text(e ?? '전체'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedYear = value);
                    _applyFilterDebounced();
                  },
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    const Text('신청가능'),
                    Switch(
                      value: _availableOnly,
                      onChanged: (value) {
                        setState(() => _availableOnly = value);
                        _applyFilterDebounced();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '최근 검색',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          buildHistory(),
          const Divider(height: 1),
          Expanded(child: buildList()),
        ],
      ),
    );
  }
}
