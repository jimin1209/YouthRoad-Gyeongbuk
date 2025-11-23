import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/providers.dart';
import '../../../application/notifiers/policy_paging_notifier.dart';
import '../../../navigation/route_paths.dart';
import '../../../data/sources/local/search_history_source.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = ref.read(policyPagingProvider);
    if (!state.hasMore || state.isLoading) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(policyPagingProvider.notifier).loadMore();
    }
  }

  Future<void> _performSearch(PolicyPagingNotifier notifier) async {
    // === 보완 패치: 검색 실행 타이밍 안정화 ===
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.search(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagingState = ref.watch(policyPagingProvider);
    final pagingNotifier = ref.read(policyPagingProvider.notifier);
    final history = ref.watch(searchHistoryListProvider);

    Widget buildList() {
      if (pagingState.error != null && pagingState.items.isEmpty) {
        return GlobalErrorView(
          message: pagingState.error!,
          onRetry: () => pagingNotifier.loadMore(reset: true),
        );
      }

      if (!pagingState.initialLoaded && pagingState.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (pagingState.items.isEmpty) {
        return GlobalErrorView(
          message: '표시할 정책이 없습니다.',
          onRetry: () => pagingNotifier.loadMore(reset: true),
        );
      }

      return RefreshIndicator(
        onRefresh: () => pagingNotifier.loadMore(reset: true),
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemBuilder: (_, i) {
            if (i >= pagingState.items.length) {
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
          itemCount: pagingState.items.length + (pagingState.isLoading ? 1 : 0),
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
                          // === 보완 패치: 검색 호출 + 타이밍 보강 ===
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            pagingNotifier.search(e.query);
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
