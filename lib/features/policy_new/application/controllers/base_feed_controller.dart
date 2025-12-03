import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_feed_type.dart';
import '../filters/policy_filter_ui_state.dart';
import 'policy_event_bus.dart';
import 'policy_paging_state.dart';
import 'policy_query_engine.dart';

abstract class BasePolicyFeedController
    extends StateNotifier<PolicyPagingState> {
  BasePolicyFeedController({
    required this.ref,
    required this.feedType,
    required this.queryEngine,
  }) : super(const PolicyPagingState.initial()) {
    ref.listen<PolicyFilterUiState>(
      policyFilterUiStateProvider,
      (previous, next) {
        if (_shouldRefreshForFilterChange(previous, next)) {
          refresh();
        }
      },
    );

    ref.listen<PolicyEvent?>(
      policyEventBusProvider,
      (previous, next) {
        if (next == null) return;
        switch (next.type) {
          case PolicyEventType.cacheCleared:
            _resetPaging();
            break;
          case PolicyEventType.refreshRequested:
            refresh();
            break;
          case PolicyEventType.favoritesChanged:
            if (feedType == PolicyFeedType.favorite ||
                feedType == PolicyFeedType.recommend) {
              refresh();
            }
            break;
          case PolicyEventType.profileUpdated:
            if (feedType == PolicyFeedType.recommend ||
                feedType == PolicyFeedType.region) {
              refresh();
            }
            break;
          case PolicyEventType.compareListChanged:
            if (feedType == PolicyFeedType.compare) {
              refresh();
            }
            break;
          case PolicyEventType.reminderChanged:
          case PolicyEventType.reminderBulkUpdated:
          case PolicyEventType.behaviorChanged:
            if (feedType == PolicyFeedType.recommend) {
              refresh();
            }
            break;
        }
      },
    );
  }

  final Ref ref;
  final PolicyFeedType feedType;
  final PolicyQueryEngine queryEngine;

  int _page = 1;
  bool _isLoading = false;

  bool get supportsFilterAutoApply =>
      feedType == PolicyFeedType.recommend ||
      feedType == PolicyFeedType.all ||
      feedType == PolicyFeedType.region ||
      feedType == PolicyFeedType.search;

  bool _shouldRefreshForFilterChange(
    PolicyFilterUiState? previous,
    PolicyFilterUiState next,
  ) {
    switch (feedType) {
      case PolicyFeedType.recommend:
        return previous == null ||
            previous.region != next.region ||
            previous.category != next.category ||
            previous.showOnlyOnline != next.showOnlyOnline ||
            previous.showOnlyOngoing != next.showOnlyOngoing ||
            !listEquals(previous.tags, next.tags);
      case PolicyFeedType.all:
        return previous == null ||
            previous.region != next.region ||
            previous.category != next.category ||
            previous.sort != next.sort ||
            previous.showOnlyOnline != next.showOnlyOnline ||
            previous.showOnlyOngoing != next.showOnlyOngoing;
      case PolicyFeedType.region:
        return previous == null ||
            previous.region != next.region ||
            previous.category != next.category ||
            previous.sort != next.sort ||
            previous.showOnlyOnline != next.showOnlyOnline ||
            previous.showOnlyOngoing != next.showOnlyOngoing;
      case PolicyFeedType.search:
        return previous == null ||
            previous.keyword != next.keyword ||
            previous.region != next.region ||
            previous.category != next.category ||
            previous.sort != next.sort ||
            previous.showOnlyOnline != next.showOnlyOnline ||
            previous.showOnlyOngoing != next.showOnlyOngoing ||
            !listEquals(previous.tags, next.tags);
      case PolicyFeedType.favorite:
      case PolicyFeedType.compare:
        return previous == null ||
            previous.sort != next.sort ||
            previous.showOnlyOnline != next.showOnlyOnline ||
            previous.showOnlyOngoing != next.showOnlyOngoing;
    }
  }

  void _resetPaging() {
    _page = 1;
    _isLoading = false;
    state = const PolicyPagingState.initial();
  }

  Future<void> ensureInitialized() async {
    if (state.items.isNotEmpty || state.isLoading) return;
    await loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    _page = 1;
    _isLoading = true;
    state = const PolicyPagingState.loading();

    final result = await queryEngine.fetch(feedType, page: _page);

    result.fold(
      onSuccess: (list) {
        state = PolicyPagingState.data(
          items: list,
          hasMore: list.length == queryEngine.pageSize,
        );
      },
      onFailure: (failure) {
        state = PolicyPagingState.error(failure);
      },
    );

    _isLoading = false;
  }

  Future<void> loadNextPage() async {
    if (_isLoading || !state.hasMore) return;

    _isLoading = true;
    final nextPage = _page + 1;

    final result = await queryEngine.fetch(feedType, page: nextPage);

    result.fold(
      onSuccess: (list) {
        final merged = [...state.items, ...list];
        state = PolicyPagingState.data(
          items: merged,
          hasMore: list.length == queryEngine.pageSize,
        );
        _page = nextPage;
      },
      onFailure: (failure) {
        state = PolicyPagingState.error(failure);
      },
    );

    _isLoading = false;
  }

  Future<void> refresh() async {
    await loadFirstPage();
  }
}
