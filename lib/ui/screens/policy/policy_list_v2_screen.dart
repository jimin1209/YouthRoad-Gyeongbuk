import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/notifiers/policy_paging_notifier.dart';
import '../../../application/providers.dart';
import '../../../application/search/providers.dart';
import '../../../data/models/policy_filter.dart';
import '../../../data/sources/local/search_history_source.dart';
import '../../../navigation/route_paths.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/compare_badge.dart';
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
  late final ScrollController _recommendedScrollController;
  late final VoidCallback _primaryScrollListener;
  late final VoidCallback _recommendedScrollListener;
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
    _recommendedScrollController = ScrollController();
    _primaryScrollListener =
        () => _onFeedScroll(PolicyFeedType.primary, _scrollController, 200);
    _recommendedScrollListener = () =>
        _onFeedScroll(PolicyFeedType.recommended, _recommendedScrollController, 160);
    _scrollController.addListener(_primaryScrollListener);
    _recommendedScrollController.addListener(_recommendedScrollListener);
    _regionSubscription = ref.listenManual<String?>(regionProvider, (prev, next) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyFilterDebounced();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchV2ControllerProvider.notifier).initialize(_buildFilter());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _regionSubscription.close();
    _scrollController.removeListener(_primaryScrollListener);
    _recommendedScrollController.removeListener(_recommendedScrollListener);
    _scrollController.dispose();
    _recommendedScrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFeedScroll(
    PolicyFeedType feed,
    ScrollController controller,
    double threshold,
  ) {
    final feeds = ref.read(policyPagingProvider);
    final state = feed == PolicyFeedType.primary ? feeds.primary : feeds.recommended;
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;
    final position = controller.position;
    if (position.pixels >= position.maxScrollExtent - threshold) {
      ref.read(policyPagingProvider.notifier).loadMore(feed);
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
    ref.read(searchV2ControllerProvider.notifier).applyFilter(_buildFilter());
  }

  void _applyFilterDebounced() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), _applyFilter);
  }

  Future<void> _performSearch() async {
    _applyFilterDebounced();
  }

  @override
  Widget build(BuildContext context) {
    final feedsState = ref.watch(policyPagingProvider);
    final pagingState = feedsState.primary;
    final searchState = ref.watch(searchV2ControllerProvider);
    final recommendedState = feedsState.recommended;
    final history = ref.watch(searchHistoryListProvider);
    final popularKeywords = ref.watch(popularSearchKeywordListProvider);
    final compareCount = ref.watch(
      compareProvider.select((value) => value.valueOrNull?.length ?? 0),
    );

    Widget buildList() {
      if ((pagingState.error != null || searchState.errorMessage != null) &&
          pagingState.items.isEmpty) {
        return GlobalErrorView(
          message: pagingState.error ?? searchState.errorMessage!,
          onRetry: () => ref.read(searchV2ControllerProvider.notifier).retry(),
        );
      }

      if (pagingState.items.isEmpty) {
        return RefreshIndicator(
          onRefresh: () => ref.read(searchV2ControllerProvider.notifier).retry(),
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text('표시할 정책이 없습니다.')),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => ref.read(searchV2ControllerProvider.notifier).retry(),
        child: ListView.separated(
          controller: _scrollController,
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

    Widget buildPopularKeywords() {
      return popularKeywords.when(
        data: (keywords) {
          if (keywords.isEmpty) return const SizedBox.shrink();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: keywords
                  .map(
                    (keyword) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(keyword),
                        onPressed: () {
                          _controller.text = keyword;
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

    Widget buildRecommendations() {
      if (recommendedState.error != null && recommendedState.items.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GlobalErrorView(
            message: recommendedState.error!,
            onRetry: () => ref
                .read(policyPagingProvider.notifier)
                .loadInitial(PolicyFeedType.recommended),
          ),
        );
      }

      if (recommendedState.isLoading && recommendedState.items.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: LinearProgressIndicator(minHeight: 2),
        );
      }

      if (recommendedState.items.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('현재 지역 기준 추천 정책이 없습니다.'),
          ),
        );
      }

      return SizedBox(
        height: 240,
        child: ListView.separated(
          controller: _recommendedScrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            if (index >= recommendedState.items.length) {
              if (!recommendedState.hasMore) {
                return const SizedBox(
                  width: 120,
                  child: Center(child: Text('모든 추천을 불러왔습니다.')),
                );
              }
              return const SizedBox(
                width: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final policy = recommendedState.items[index];
            return SizedBox(
              width: 320,
              child: PolicyCardV2(
                policy: policy,
                onTap: () => context.push(RoutePaths.policyDetail(policy.id)),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemCount: recommendedState.items.length +
              (recommendedState.isLoadingMore || recommendedState.hasMore ? 1 : 0),
        ),
      );
    }

    return Scaffold(
      appBar: AppAppBar(
        title: '정책 목록',
        actions: [
          IconButton(
            tooltip: '찜한 정책',
            icon: const Icon(Icons.favorite_border),
            onPressed: () => context.push(RoutePaths.favorites),
          ),
          CompareBadge(
            child: IconButton(
              tooltip: '비교함',
              icon: const Icon(Icons.balance_outlined),
              onPressed: () => context.push(RoutePaths.compare),
            ),
          ),
        ],
      ),
      floatingActionButton: compareCount == 0
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(RoutePaths.compare),
              icon: const Icon(Icons.balance),
              label: Text('비교하기 ($compareCount)'),
            ),
      body: Column(
        children: [
          if ((pagingState.isLoading || searchState.isInitializing) &&
              pagingState.items.isNotEmpty)
            const LinearProgressIndicator(minHeight: 2),
          if (searchState.errorMessage != null && pagingState.items.isNotEmpty)
            MaterialBanner(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              content: Text(
                searchState.errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
              ),
              actions: [
                TextButton(
                  onPressed: () => ref.read(searchV2ControllerProvider.notifier).retry(),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          if (recommendedState.error != null && recommendedState.items.isNotEmpty)
            MaterialBanner(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              content: Text(
                recommendedState.error!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
              ),
              actions: [
                TextButton(
                  onPressed: () => ref
                      .read(policyPagingProvider.notifier)
                      .loadInitial(PolicyFeedType.recommended),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '정책명을 입력하세요',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
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
          buildPopularKeywords(),
          buildHistory(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '추천 정책',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          buildRecommendations(),
          const Divider(height: 1),
          Expanded(
            child: (pagingState.isLoading || searchState.isInitializing) &&
                    pagingState.items.isEmpty
                ? const _InitialLoadingList()
                : buildList(),
          ),
        ],
      ),
    );
  }
}

class _InitialLoadingList extends StatelessWidget {
  const _InitialLoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, __) => const _PolicyPlaceholderCard(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: 6,
    );
  }
}

class _PolicyPlaceholderCard extends StatelessWidget {
  const _PolicyPlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 12,
            width: 180,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
