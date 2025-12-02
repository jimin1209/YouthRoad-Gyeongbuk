import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers.dart';
import '../../../application/policy/policy_list_notifier.dart';
import '../../widgets/global_error_view.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/policy_card.dart';

class PolicyListLegacyScreen extends ConsumerWidget {
  const PolicyListLegacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(policyListNotifierProvider);
    final notifier = ref.read(policyListNotifierProvider.notifier);
    return Scaffold(
      appBar: const AppAppBar(title: '레거시 정책 목록'),
      body: state.isLoading && state.policies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && state.policies.isEmpty
              ? GlobalErrorView(
                  message: PolicyListNotifier.errorMessage,
                  onRetry: notifier.refresh,
                )
              : RefreshIndicator(
                  onRefresh: notifier.refresh,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      final metrics = notification.metrics;
                      if (metrics.maxScrollExtent <= 0) return false;
                      if (metrics.pixels >= metrics.maxScrollExtent * 0.9) {
                        notifier.loadNextPage();
                      }
                      return false;
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (_, i) {
                        if (i >= state.policies.length) {
                          if (!state.hasMore) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(child: Text('모든 정책을 불러왔습니다.')),
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return PolicyCard(policy: state.policies[i]);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemCount:
                          state.policies.length + (state.isLoadingMore || state.hasMore ? 1 : 0),
                    ),
                  ),
                ),
    );
  }
}
