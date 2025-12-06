import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_feed_type.dart';
import '../filters/policy_filter_ui_state.dart';
import '../../../../application/notifiers/region_notifier.dart';
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
      (_, next) => forceReload(next),
    );

    ref.listen<String?>(
      regionProvider,
      (previous, next) {
        if (previous != next) {
          onRegionChanged();
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

  void _resetPaging() {
    _page = 1;
    _isLoading = false;
    state = const PolicyPagingState.initial();
  }

  Future<void> ensureInitialized() async {
    if (state.items.isNotEmpty || state.isLoading) return;
    await loadFirstPage();
  }

  Future<void> loadFirstPage() async =>
      reload(ref.read(policyFilterUiStateProvider));

  Future<void> loadNextPage() async {
    if (_isLoading) return;
    if (!state.hasMore) {
      debugPrint('[PAGING-LAST-PAGE:NO-OP] feed=${feedType.name}, page=$_page');
      return;
    }
    if (!_shouldFetchForFeedType(ref.read(policyFilterUiStateProvider))) return;

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
    await reload(ref.read(policyFilterUiStateProvider));
  }

  /// 지역 등 주요 조건 변경 시 사용: 페이징 초기화 후 첫 페이지 재로딩
  Future<void> onRegionChanged() async {
    await reload(ref.read(policyFilterUiStateProvider));
  }

  Future<void> reload(PolicyFilterUiState filter) async {
    await forceReload(filter);
  }

  Future<void> forceReload(PolicyFilterUiState filter) async {
    _page = 1;
    _isLoading = true;
    state = const PolicyPagingState.loading();

    final shouldFetch = _shouldFetchForFeedType(filter);

    if (!shouldFetch) {
      _isLoading = false;
      state = const PolicyPagingState.initial();
      return;
    }

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

  bool _shouldFetchForFeedType(PolicyFilterUiState filter) {
    if (feedType != PolicyFeedType.search) {
      return true;
    }

    final keyword = filter.keyword.trim();
    final hasKeyword = keyword.length >= 2;
    final hasTags = filter.tags.isNotEmpty;

    return hasKeyword || hasTags;
  }
}
