import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/controllers/base_feed_controller.dart';
import '../../application/controllers/policy_paging_state.dart';
import '../../application/providers.dart';
import '../../domain/values/policy_feed_type.dart';
import '../detail/policy_detail_bottom_sheet.dart';
import 'policy_card.dart';
import 'policy_list_empty.dart';
import 'policy_list_error.dart';
import 'policy_list_loading.dart';

class PolicyFeedListView extends ConsumerWidget {
  const PolicyFeedListView({
    super.key,
    required this.feedType,
  });

  final PolicyFeedType feedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (state, notifier) = _useController(ref);

    notifier.ensureInitialized();

    if (state.failure != null) {
      return PolicyListError(
        message: state.failure!.message,
        onRetry: () => notifier.loadFirstPage(),
      );
    }

    if (state.isLoading && state.items.isEmpty) {
      return const PolicyListLoading();
    }

    if (!state.isLoading && state.items.isEmpty) {
      return const PolicyListEmpty();
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < state.items.length) {
            final policy = state.items[index];
            return PolicyCard(
              policy: policy,
              onTap: () => _openDetail(context, policy.id),
            );
          }

          notifier.loadNextPage();
          return const PolicyListLoading();
        },
      ),
    );
  }

  (PolicyPagingState, BasePolicyFeedController) _useController(WidgetRef ref) {
    switch (feedType) {
      case PolicyFeedType.recommend:
        return (
          ref.watch(recommendFeedControllerProvider),
          ref.read(recommendFeedControllerProvider.notifier),
        );
      case PolicyFeedType.all:
        return (
          ref.watch(allFeedControllerProvider),
          ref.read(allFeedControllerProvider.notifier),
        );
      case PolicyFeedType.region:
        return (
          ref.watch(regionFeedControllerProvider),
          ref.read(regionFeedControllerProvider.notifier),
        );
      case PolicyFeedType.search:
        return (
          ref.watch(searchFeedControllerProvider),
          ref.read(searchFeedControllerProvider.notifier),
        );
      case PolicyFeedType.favorite:
        return (
          ref.watch(favoriteFeedControllerProvider),
          ref.read(favoriteFeedControllerProvider.notifier),
        );
      case PolicyFeedType.compare:
        return (
          ref.watch(compareFeedControllerProvider),
          ref.read(compareFeedControllerProvider.notifier),
        );
    }
  }

  void _openDetail(BuildContext context, String policyId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => PolicyDetailBottomSheet(policyId: policyId),
    );
  }
}
