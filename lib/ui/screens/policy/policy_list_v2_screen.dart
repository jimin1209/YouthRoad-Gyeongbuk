import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/providers.dart';
import '../../../navigation/route_paths.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/policy_card_v2.dart';

class PolicyListV2Screen extends ConsumerWidget {
  const PolicyListV2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(policyPagingProvider);
    final notifier = ref.read(policyPagingProvider.notifier);

    return Scaffold(
      appBar: const AppAppBar(title: '정책 목록 v2'),
      body: RefreshIndicator(
        onRefresh: () => notifier.loadMore(reset: true),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.items.length + 1,
          itemBuilder: (context, index) {
            if (index < state.items.length) {
              final policy = state.items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PolicyCardV2(
                  policy: policy,
                  onTap: () => context.push(RoutePaths.policyDetail(policy.id)),
                ),
              );
            }
            if (state.isLoading) {
              return const Center(child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(),
              ));
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: TextButton.icon(
                  onPressed: state.hasMore ? () => notifier.loadMore() : null,
                  icon: const Icon(Icons.refresh),
                  label: Text(state.hasMore ? '더 불러오기' : '모든 정책을 확인했습니다'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
