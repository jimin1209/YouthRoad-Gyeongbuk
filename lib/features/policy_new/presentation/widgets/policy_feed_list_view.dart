import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/behavior/policy_behavior_tracker.dart';
import '../../application/controllers/base_feed_controller.dart';
import '../../application/controllers/ui_reaction_controller.dart';
import '../../application/controllers/policy_paging_state.dart';
import '../../application/providers.dart';
import '../../domain/entities/policy.dart';
import '../../domain/values/policy_feed_type.dart';
import '../detail/policy_detail_bottom_sheet.dart';
import 'policy_feed_reaction_banner.dart';
import 'policy_card.dart';
import 'policy_list_empty.dart';
import 'policy_list_error.dart';
import 'policy_list_loading.dart';
import 'policy_list_skeleton.dart';
import 'policy_search_empty_view.dart';
import '../../../../ui/common/empty_result_view.dart';

class PolicyFeedListView extends ConsumerStatefulWidget {
  const PolicyFeedListView({
    super.key,
    required this.feedType,
    this.externalScrollController,
  });

  final PolicyFeedType feedType;
  final ScrollController? externalScrollController;

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
    _scrollController =
        (widget.externalScrollController ?? ScrollController())
          ..addListener(_onScroll);

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
    if (widget.externalScrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final queryState = ref.watch(policyQueryProvider(widget.feedType));
    final query = queryState.query;
    final (state, notifier) = _useController();
    final reaction = ref.watch(uiReactionControllerProvider(widget.feedType));
    _latestState = state;
    _latestController = notifier;

    if (_isLoadingMore && (!state.hasMore || state.failure != null)) {
      _isLoadingMore = false;
    }

    final visibleItems = state.visibleItems;
    final isPristine = !state.isLoading &&
        state.previousResults == null &&
        visibleItems.isEmpty &&
        reaction.phase == UIReactionPhase.idle;
    final isInitialLoading = (state.isLoading || isPristine) &&
        visibleItems.isEmpty;
    final isTransitionLoading = state.isLoading && state.previousResults != null;
    var showSkeleton =
        reaction.shouldHoldSkeleton || isInitialLoading || isTransitionLoading;
    if (state.failure != null) {
      showSkeleton = false;
    }

    final keyword = query.keyword?.trim() ?? '';
    final hasKeyword = keyword.isNotEmpty;
    final isKeywordTooShort = hasKeyword && keyword.length < 2;
    final hasTags = query.tags.isNotEmpty || query.filter.tags.isNotEmpty;

    final shouldShowSearchGuide =
        widget.feedType == PolicyFeedType.search &&
            visibleItems.isEmpty &&
            !isInitialLoading &&
            !hasTags &&
            (!hasKeyword || isKeywordTooShort);

    Widget content;

    if (state.failure != null) {
      content = PolicyListError(
        key: const ValueKey('policy-list-error'),
        message: state.failure!.message,
        onRetry: notifier.loadFirstPage,
      );
    } else if (isInitialLoading) {
      content = const PolicyListSkeleton(
        key: ValueKey('policy-list-initial-loading'),
      );
    } else if (shouldShowSearchGuide) {
      content = PolicySearchEmptyView(
        key: const ValueKey('policy-search-guide'),
        isKeywordTooShort: isKeywordTooShort,
        feedType: widget.feedType,
      );
    } else if (!state.isLoading && visibleItems.isEmpty) {
      if (widget.feedType == PolicyFeedType.favorite ||
          widget.feedType == PolicyFeedType.bookmarked) {
        content = PolicyListEmpty(
          key: const ValueKey('policy-list-empty-favorite'),
          message:
              '즐겨찾기한 정책이 없습니다.\n마음에 드는 정책의 하트 버튼을 눌러 저장해보세요.',
          summary: null,
        );
      } else {
        content = const EmptyResultView(
          key: ValueKey('policy-list-empty-standard'),
        );
      }
    } else {
      content = RefreshIndicator(
        key: const ValueKey('policy-list-content'),
        onRefresh: notifier.refresh,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          cacheExtent: 600,
          addAutomaticKeepAlives: false,
          addSemanticIndexes: false,
          addRepaintBoundaries: false,
          itemCount: visibleItems.length +
              (_shouldShowFooterLoader(state, visibleItems) ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < visibleItems.length) {
              final policy = visibleItems[index];
              return RepaintBoundary(
                child: PolicyCard(
                  key: ValueKey('policy-${policy.id}'),
                  policy: policy,
                  onTap: () {
                    ref
                        .read(policyBehaviorTrackerProvider.notifier)
                        .recordDetailView(policy);
                    _openDetail(context, policy.id);
                  },
                ),
              );
            }

            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: PolicyListLoading(),
            );
          },
        ),
      );

      if (showSkeleton) {
        content = Stack(
          key: const ValueKey('policy-list-content'),
          children: [
            Positioned.fill(child: content),
            const Positioned.fill(
              child: IgnorePointer(child: PolicyListSkeleton()),
            ),
          ],
        );
      }
    }

    return Column(
      children: [
        PolicyFeedReactionBanner(
          state: reaction,
          onRetry: notifier.loadFirstPage,
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeOut,
            child: content,
          ),
        ),
      ],
    );
  }

  bool _shouldShowFooterLoader(PolicyPagingState state, List<Policy> items) {
    if (items.isEmpty) return false;
    if (state.previousResults != null) return false;
    return _isLoadingMore || (state.isLoading && state.hasMore);
  }

  (PolicyPagingState, BasePolicyFeedController) _useController() {
    switch (widget.feedType) {
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
      case PolicyFeedType.bookmarked:
        return (
          ref.watch(bookmarkedFeedControllerProvider),
          ref.read(bookmarkedFeedControllerProvider.notifier),
        );
      case PolicyFeedType.compare:
        throw UnsupportedError('Compare feed는 별도 화면을 사용합니다.');
    }
  }

  BasePolicyFeedController _controllerFor(WidgetRef ref) {
    switch (widget.feedType) {
      case PolicyFeedType.all:
        return ref.read(allFeedControllerProvider.notifier);
      case PolicyFeedType.region:
        return ref.read(regionFeedControllerProvider.notifier);
      case PolicyFeedType.search:
        return ref.read(searchFeedControllerProvider.notifier);
      case PolicyFeedType.favorite:
        return ref.read(favoriteFeedControllerProvider.notifier);
      case PolicyFeedType.bookmarked:
        return ref.read(bookmarkedFeedControllerProvider.notifier);
      case PolicyFeedType.compare:
        throw UnsupportedError('Compare feed는 별도 화면을 사용합니다.');
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
    final navigator = Navigator.of(context);
    final overlay = navigator.overlay;
    final springController =
        overlay != null ? BottomSheet.createAnimationController(overlay) : null;

    springController?.duration = const Duration(milliseconds: 350);
    springController?.reverseDuration = const Duration(milliseconds: 300);
    springController?.drive(
      CurveTween(curve: const _BottomSheetSpringCurve()),
    );

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      transitionAnimationController: springController,
      builder: (_) => PolicyDetailBottomSheet(policyId: policyId),
    );
  }
}

class _BottomSheetSpringCurve extends Curve {
  const _BottomSheetSpringCurve();

  @override
  double transform(double t) {
    const spring = SpringDescription(
      mass: 0.75,
      stiffness: 250,
      damping: 18,
    );

    final simulation = SpringSimulation(spring, 0, 1, 0);
    final value = simulation.x(t.clamp(0, 1));

    return value.clamp(0.0, 1.0);
  }
}
