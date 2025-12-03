import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/behavior/policy_behavior_tracker.dart';
import '../../application/controllers/base_feed_controller.dart';
import '../../application/controllers/policy_paging_state.dart';
import '../../application/providers.dart';
import '../../domain/values/policy_feed_type.dart';
import '../detail/policy_detail_bottom_sheet.dart';
import 'policy_card.dart';
import 'policy_list_empty.dart';
import 'policy_list_error.dart';
import 'policy_list_loading.dart';

class PolicyFeedListView extends ConsumerStatefulWidget {
  const PolicyFeedListView({
    super.key,
    required this.feedType,
  });

  final PolicyFeedType feedType;

  @override
  ConsumerState<PolicyFeedListView> createState() => _PolicyFeedListViewState();
}

class _PolicyFeedListViewState extends ConsumerState<PolicyFeedListView>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  PolicyPagingState? _latestState;
  BasePolicyFeedController? _latestController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllerFor(ref).ensureInitialized();
    });
  }

  @override
  void didUpdateWidget(covariant PolicyFeedListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.feedType != widget.feedType) {
      _resetFeedState();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final (state, notifier) = _useController();
    _latestState = state;
    _latestController = notifier;

    if (_isLoadingMore && (!state.hasMore || state.failure != null)) {
      _isLoadingMore = false;
    }

    if (state.failure != null) {
      return PolicyListError(
        message: state.failure!.message,
        onRetry: notifier.loadFirstPage,
      );
    }

    if (state.isLoading && state.items.isEmpty) {
      return const PolicyListLoading();
    }

    if (!state.isLoading && state.items.isEmpty) {
      return const PolicyListEmpty();
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
            state.items.length + (_shouldShowFooterLoader(state) ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < state.items.length) {
            final policy = state.items[index];
            return PolicyCard(
              policy: policy,
              onTap: () {
                ref
                    .read(policyBehaviorTrackerProvider.notifier)
                    .recordDetailView(policy);
                _openDetail(context, policy.id);
              },
            );
          }

          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: PolicyListLoading(),
          );
        },
      ),
    );
  }

  bool _shouldShowFooterLoader(PolicyPagingState state) {
    if (state.items.isEmpty) return false;
    return _isLoadingMore || (state.isLoading && state.hasMore);
  }

  (PolicyPagingState, BasePolicyFeedController) _useController() {
    switch (widget.feedType) {
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

  BasePolicyFeedController _controllerFor(WidgetRef ref) {
    switch (widget.feedType) {
      case PolicyFeedType.recommend:
        return ref.read(recommendFeedControllerProvider.notifier);
      case PolicyFeedType.all:
        return ref.read(allFeedControllerProvider.notifier);
      case PolicyFeedType.region:
        return ref.read(regionFeedControllerProvider.notifier);
      case PolicyFeedType.search:
        return ref.read(searchFeedControllerProvider.notifier);
      case PolicyFeedType.favorite:
        return ref.read(favoriteFeedControllerProvider.notifier);
      case PolicyFeedType.compare:
        return ref.read(compareFeedControllerProvider.notifier);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final state = _latestState;
    final controller = _latestController;
    if (state == null || controller == null) return;

    if (state.isLoading) return;

    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return;

    final threshold = position.maxScrollExtent - 200;
    if (position.pixels >= threshold && !_isLoadingMore && state.hasMore) {
      _triggerPagination(controller);
    }
  }

  void _triggerPagination(BasePolicyFeedController controller) {
    setState(() {
      _isLoadingMore = true;
    });

    controller.loadNextPage().whenComplete(() {
      if (!mounted) return;
      setState(() {
        _isLoadingMore = false;
      });
    });
  }

  void _resetFeedState() {
    if (!mounted) return;

    setState(() {
      _isLoadingMore = false;
      _latestState = null;
      _latestController = null;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      _controllerFor(ref).ensureInitialized();
    });
  }

  @override
  bool get wantKeepAlive => true;

  void _openDetail(BuildContext context, String policyId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => PolicyDetailBottomSheet(policyId: policyId),
    );
  }
}
