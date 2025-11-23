import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/notifiers/policy_list_notifier.dart';
import '../../../application/providers.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _performSearch(PolicyListNotifier notifier) async {
    await notifier.search(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final policies = ref.watch(policyListNotifierProvider);
    final notifier = ref.read(policyListNotifierProvider.notifier);
    final history = ref.watch(searchHistoryListProvider);

    Widget buildList() {
      return policies.when(
        data: (list) {
          if (list.isEmpty) {
            return GlobalErrorView(
              message: '표시할 정책이 없습니다.',
              onRetry: () => notifier.refreshPolicies(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => notifier.refreshPolicies(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, i) {
                final policy = list[i];
                return PolicyCardV2(
                  policy: policy,
                  onTap: () => context.push(RoutePaths.policyDetail(policy.id)),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: list.length,
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => GlobalErrorView(
          message: PolicyListNotifier.errorMessage,
          onRetry: notifier.refreshPolicies,
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
                          notifier.search(e.query);
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
                  onPressed: () => _performSearch(notifier),
                ),
              ),
              onSubmitted: (_) => _performSearch(notifier),
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
