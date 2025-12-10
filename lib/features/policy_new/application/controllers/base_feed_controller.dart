import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_query.dart';
import '../../domain/values/policy_status_filter.dart';
import '../filters/policy_filter_ui_state.dart';
import '../filters/policy_search_keyword_provider.dart';
import '../../../../application/notifiers/region_notifier.dart';
import 'policy_event_bus.dart';
import 'policy_feed_memory_cache.dart';
import 'policy_paging_state.dart';
import 'policy_query_engine.dart';
import 'policy_query_state.dart';
import 'ui_reaction_controller.dart';

abstract class BasePolicyFeedController
    extends StateNotifier<PolicyPagingState> {
  BasePolicyFeedController({
    required this.ref,
    required this.feedType,
    required this.queryEngine,
    required PolicyFeedMemoryCache memoryCache,
  })  : _memoryCache = memoryCache,
        super(const PolicyPagingState.initial()) {
    ref.listen<PolicyFilterUiState>(
      globalFilterProvider,
      (_, __) => _onQueryChanged(),
    );

    ref.listen<String>(
      policySearchKeywordProvider(feedType),
      (_, __) => _onQueryChanged(),
    );

    ref.listen<String?>(
      regionProvider,
      (previous, next) {
        if (previous != next) {
          _reloadCurrentQuery(force: true);
        }
      },
    );

    ref.listen<PolicyEvent?>(
      policyEventBusProvider,
      (previous, next) {
        if (next == null) return;
        switch (next.type) {
          case PolicyEventType.cacheCleared:
            _memoryCache.evictFeed(feedType);
            _resetPaging();
            break;
          case PolicyEventType.refreshRequested:
            refresh();
            break;
          case PolicyEventType.favoritesChanged:
            if (feedType == PolicyFeedType.favorite ||
                feedType == PolicyFeedType.bookmarked ||
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
  final PolicyFeedMemoryCache _memoryCache;
  UIReactionController get _reaction =>
      ref.read(uiReactionControllerProvider(feedType).notifier);

  PolicyQueryState? _currentQuery;

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
    _currentQuery = null;
    state = const PolicyPagingState.initial();
  }

  Future<void> ensureInitialized() async {
    if (state.visibleItems.isNotEmpty || state.isLoading) return;
    await _reloadCurrentQuery();
  }

  Future<void> loadFirstPage() async => _reloadCurrentQuery(force: true);

  Future<void> loadNextPage() async {
    if (_isLoading) return;
    if (!state.hasMore) {
      debugPrint('[PAGING-LAST-PAGE:NO-OP] feed=${feedType.name}, page=$_page');
      return;
    }

    final queryState = _currentQuery ?? queryEngine.buildQueryState(feedType);

    if (!_shouldFetchForFeedType(queryState.query)) return;

    _isLoading = true;
    final nextPage = _page + 1;

    final result = await queryEngine.fetch(
      feedType,
      page: nextPage,
      queryState: queryState,
    );

    result.fold(
      onSuccess: (list) {
        final merged = [...state.currentResults, ...list];
        state = PolicyPagingState.data(
          items: merged,
          hasMore: list.length == queryEngine.pageSize,
        );
        _page = nextPage;
        _memoryCache.save(feedType, queryState, state, page: _page);
      },
      onFailure: (failure) {
        state = PolicyPagingState.error(failure);
      },
    );

    _isLoading = false;
  }

  Future<void> refresh() async {
    await _reloadCurrentQuery(force: true);
  }

  bool _shouldFetchForFeedType(PolicyQuery query) {
    if (feedType != PolicyFeedType.search) {
      return true;
    }

    final keyword = query.keyword?.trim() ?? '';
    final hasKeyword = keyword.length >= 2;
    final hasTags = query.tags.isNotEmpty || query.filter.tags.isNotEmpty;

    return hasKeyword || hasTags;
  }

  Future<void> _onQueryChanged() async {
    final queryState = queryEngine.buildQueryState(feedType);
    final filter = queryState.query.filter;
    final previousStatus = _currentQuery?.query.filter.status;
    final hasStatusChanged =
        previousStatus != queryState.query.filter.status;

    if (hasStatusChanged) {
      _resetPaging();
      _page = 1;
      debugPrint(
        '[Feed][STATUS-CHANGE] feed=${feedType.name}, '
        'status=${filter.status.queryValue}, '
        'region=${filter.region.name}/${filter.province}/${filter.city ?? '-'} '
        '(${filter.district ?? '-'}), '
        'sort=${queryState.query.sort.name}, '
        'keyword=${queryState.query.keyword ?? '-'}, '
        'page=$_page',
      );
      _currentQuery = queryState;
      await _fetchFirstPage(queryState);
      return;
    }

    if (_currentQuery?.hash == queryState.hash) {
      _reaction.markRestored(queryState.hash);
      _restoreFromCache(queryState);
      return;
    }

    _currentQuery = queryState;
    await _restoreOrFetch(queryState);
  }

  Future<void> _reloadCurrentQuery({bool force = false}) async {
    final queryState = queryEngine.buildQueryState(feedType);
    if (!force && _currentQuery?.hash == queryState.hash) {
      _reaction.markRestored(queryState.hash);
      _restoreFromCache(queryState);
      return;
    }

    _currentQuery = queryState;
    await _fetchFirstPage(queryState);
  }

  Future<void> _restoreOrFetch(PolicyQueryState queryState) async {
    if (_restoreFromCache(queryState)) {
      return;
    }

    await _fetchFirstPage(queryState);
  }

  bool _restoreFromCache(PolicyQueryState queryState) {
    final cached = _memoryCache.restore(feedType, queryState.hash);
    if (cached == null) return false;

    _page = cached.page;
    _currentQuery = queryState;
    _isLoading = false;
    state = cached.state;
    return true;
  }

  Future<void> _fetchFirstPage(PolicyQueryState queryState) async {
    _page = 1;
    await _fetchPage(queryState, page: _page, append: false);
  }

  Future<void> _fetchPage(
    PolicyQueryState queryState, {
    required int page,
    required bool append,
  }) async {
    if (_isLoading) return;

    final previousItems = List<Policy>.from(state.visibleItems);
    final previousResults = previousItems.isEmpty ? null : previousItems;
    final isInitialLoad = !append && previousItems.isEmpty;

    final shouldFetch = _shouldFetchForFeedType(queryState.query);

    if (!shouldFetch) {
      _isLoading = false;
      state = const PolicyPagingState.initial();
      _memoryCache.save(feedType, queryState, state, page: 1);
      _reaction.markUnchanged(queryState.hash);
      return;
    }

    final fetchPrefix = (feedType == PolicyFeedType.all ||
            feedType == PolicyFeedType.region ||
            feedType == PolicyFeedType.search)
        ? '[Policy][Explore][FETCH]'
        : '[Feed][FETCH]';

    debugPrint(
      '$fetchPrefix feed=${feedType.name}, '
      'queryFeed=${queryState.query.feedType.name}, '
      'status=${queryState.query.filter.status.queryValue}, '
      'region=${queryState.query.filter.region.name}/${queryState.query.filter.province}/${queryState.query.filter.city ?? '-'} '
      '(${queryState.query.filter.district ?? '-'}), '
      'sort=${queryState.query.sort.name}, '
      'keyword=${queryState.query.keyword ?? '-'}, '
      'page=$page',
    );

    _isLoading = true;
    if (!append) {
      _reaction.markLoading(queryState.hash, isInitialLoad: isInitialLoad);
    }
    if (!append) {
      state = PolicyPagingState.loading(previousResults: previousResults);
    }

    final result = await queryEngine.fetch(
      feedType,
      page: page,
      queryState: queryState,
    );

    result.fold(
      onSuccess: (list) {
        final merged = append ? [...state.currentResults, ...list] : list;
        state = PolicyPagingState.data(
          items: merged,
          hasMore: list.length == queryEngine.pageSize,
        );
        _page = page;
        _memoryCache.save(feedType, queryState, state, page: _page);
        _reaction.markResult(
          queryHash: queryState.hash,
          changed: !_areSameItems(previousItems, merged),
        );
      },
      onFailure: (failure) {
        state = PolicyPagingState.error(failure, previousResults: previousResults);
        _reaction.markFailure(
          queryHash: queryState.hash,
          message: failure.message,
        );
      },
    );

    _isLoading = false;
  }

  bool _areSameItems(List<Policy> prev, List<Policy> next) {
    if (prev.length != next.length) return false;
    for (var i = 0; i < prev.length; i++) {
      if (prev[i].id != next[i].id) return false;
    }
    return true;
  }
}
