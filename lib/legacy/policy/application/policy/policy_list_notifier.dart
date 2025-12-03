// FILE: lib/legacy/policy/application/policy/policy_list_notifier.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youth_road_app/application/di.dart';
import 'package:youth_road_app/application/notifiers/region_notifier.dart';
import 'package:youth_road_app/data/models/policy_filter.dart';
import 'package:youth_road_app/data/sources/local/search_history_source.dart';
import 'package:youth_road_app/domain/entities/policy.dart';
import 'package:youth_road_app/domain/repositories/policy_repository.dart';

class PolicyListState {
  const PolicyListState({
    this.policies = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.error,
    this.isStale = false,
  });

  final List<Policy> policies;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final Object? error;
  final bool isStale;

  PolicyListState copyWith({
    List<Policy>? policies,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    Object? error = _noUpdate,
    bool? isStale,
  }) {
    return PolicyListState(
      policies: policies ?? this.policies,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      error: error == _noUpdate ? this.error : error,
      isStale: isStale ?? this.isStale,
    );
  }

  static const _noUpdate = Object();
}

final policyListNotifierProvider =
    NotifierProvider.autoDispose<PolicyListNotifier, PolicyListState>(
  PolicyListNotifier.new,
);

class PolicyListNotifier extends AutoDisposeNotifier<PolicyListState> {
  static const String errorMessage = '정책을 불러오지 못했습니다.';
  static const int _pageSize = 10;

  String? _lastQuery;
  bool _initialLoadScheduled = false;
  int _requestCounter = 0;

  PolicyRepository get _repo => ref.read(policyRepositoryInterfaceProvider);

  SearchHistorySource get _historySource => ref.read(searchHistorySourceProvider);

  @override
  PolicyListState build() {
    final region = ref.watch(regionProvider);
    final normalizedRegion = region?.trim() ?? '';
    debugPrint('[PolicyListNotifier] build() with region=$region');

    if (!_initialLoadScheduled) {
      _initialLoadScheduled = true;
      Future.microtask(() {
        debugPrint('[PolicyListNotifier] scheduling initial load');
        _loadPolicies(
          region: normalizedRegion,
          forceRefresh: false,
          isUserRefresh: false,
          page: 1,
          append: false,
        );
      });
    }

    ref.listen<String?>(regionProvider, (previous, next) {
      if (previous == next) return;
      debugPrint(
        '[PolicyListNotifier] region changed: $previous -> $next, reloading policies',
      );
      _loadPolicies(
        region: (next ?? '').trim(),
        forceRefresh: false,
        isUserRefresh: false,
        page: 1,
        append: false,
      );
    });

    ref.onDispose(() {
      debugPrint('[PolicyListNotifier] disposed');
    });

    return const PolicyListState(isLoading: true);
  }

  PolicyFilter _buildFilter({
    required String region,
    required int page,
  }) {
    final normalizedRegion = region.trim();
    return PolicyFilter(
      searchRgnSe: normalizedRegion.isEmpty ? null : normalizedRegion,
      searchText: _lastQuery,
      availableOnly: true,
      pageIndex: page,
      recordCount: _pageSize,
      pagingYn: 'Y',
    );
  }

  int _nextRequestId() => ++_requestCounter;

  bool _isLatestRequest(int requestId) => requestId == _requestCounter;

  Future<void> _loadPolicies({
    required String region,
    required bool forceRefresh,
    required bool isUserRefresh,
    required int page,
    required bool append,
  }) async {
    if (kDebugMode) {
      try {
        // Accessing state to ensure provider is initialized.
        // ignore: unused_local_variable
        final _ = state;
      } catch (e, st) {
        debugPrint(
          '[PolicyListNotifier] WARNING: _loadPolicies called before build completion: $e',
        );
        debugPrint('$st');
      }
    }

    final requestId = _nextRequestId();
    if (append &&
        (state.isLoadingMore || state.isLoading || !state.hasMore || page <= 1)) {
      return;
    }

    final previousPolicies = state.policies;
    final normalizedRegion = region.trim();
    final filter = _buildFilter(region: normalizedRegion, page: page);

    debugPrint(
      '[PolicyListNotifier][#$requestId] load start | '
      'region="$normalizedRegion" forceRefresh=$forceRefresh refresh=$isUserRefresh '
      'page=$page append=$append prevPolicies=${previousPolicies.length}',
    );

    state = state.copyWith(
      isLoading: append ? state.isLoading : !isUserRefresh,
      isRefreshing: isUserRefresh,
      isLoadingMore: append,
      hasMore: append ? state.hasMore : true,
      page: append ? state.page : page,
      error: null,
      isStale: append ? state.isStale : previousPolicies.isNotEmpty,
    );

    try {
      if (append) {
        final policies = await _repo.refreshPolicies(filter: filter);

        if (!_isLatestRequest(requestId)) {
          debugPrint(
            '[PolicyListNotifier][#$requestId] stale append result discarded '
            '(latest=#$_requestCounter)',
          );
          return;
        }

        final merged = [...previousPolicies, ...policies];
        state = state.copyWith(
          policies: merged,
          isLoadingMore: false,
          isLoading: false,
          isRefreshing: false,
          hasMore: policies.length >= _pageSize,
          page: page,
          error: null,
          isStale: false,
        );
        debugPrint(
          '[PolicyListNotifier][#$requestId] append success: '
          'received=${policies.length} total=${merged.length} hasMore=${state.hasMore}',
        );
      } else {
        final result = await _repo.getPolicies(
          filter: filter,
          forceRefresh: forceRefresh,
        );

        if (!_isLatestRequest(requestId)) {
          debugPrint(
            '[PolicyListNotifier][#$requestId] stale cache result discarded '
            '(latest=#$_requestCounter)',
          );
          return;
        }

        final remoteFuture = result.remoteRefresh;
        final hasInitialPolicies = result.policies.isNotEmpty;
        final shouldKeepPrevious = !hasInitialPolicies && remoteFuture != null;
        final policiesToApply = shouldKeepPrevious ? previousPolicies : result.policies;
        final shouldMarkStale =
            remoteFuture != null && (hasInitialPolicies || previousPolicies.isNotEmpty);

        state = state.copyWith(
          policies: policiesToApply,
          isLoading: false,
          isRefreshing: isUserRefresh && remoteFuture != null,
          isLoadingMore: false,
          isStale: shouldMarkStale,
          hasMore: policiesToApply.length >= _pageSize,
          page: page,
          error: null,
        );
        debugPrint(
          '[PolicyListNotifier][#$requestId] cache applied: '
          'count=${policiesToApply.length} stale=$shouldMarkStale '
          'keptPrevious=$shouldKeepPrevious hasMore=${state.hasMore}',
        );

        remoteFuture?.then((latest) {
          if (!_isLatestRequest(requestId)) {
            debugPrint(
              '[PolicyListNotifier][#$requestId] remote result discarded '
              '(latest=#$_requestCounter)',
            );
            return;
          }

          state = state.copyWith(
            policies: latest,
            isStale: false,
            isRefreshing: false,
            isLoadingMore: false,
            hasMore: latest.length >= _pageSize,
            page: page,
            error: null,
          );
          debugPrint(
            '[PolicyListNotifier][#$requestId] remote refresh success. count=${latest.length} hasMore=${state.hasMore}',
          );
        }).catchError((error, stack) {
          if (!_isLatestRequest(requestId)) {
            debugPrint(
              '[PolicyListNotifier][#$requestId] remote error discarded '
              '(latest=#$_requestCounter)',
            );
            return;
          }

          debugPrint('[PolicyListNotifier][#$requestId] remote refresh failed: error=$error');
          debugPrint('$stack');
          state = state.copyWith(
            error: error,
            isStale: false,
            isRefreshing: false,
            isLoadingMore: false,
          );
        });
      }
    } catch (e, st) {
      if (!_isLatestRequest(requestId)) {
        debugPrint(
          '[PolicyListNotifier][#$requestId] error discarded (latest=#$_requestCounter)',
        );
        return;
      }

      debugPrint('[PolicyListNotifier][#$requestId] remote refresh failed: error=$e');
      debugPrint('$st');
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        error: e,
        isStale: false,
      );
    }

    _debugLogState('after _loadPolicies #$requestId');
  }

  Future<void> refresh() async {
    final region = (ref.read(regionProvider) ?? '').trim();
    debugPrint('[PolicyListNotifier] refresh() start with region=$region');

    await _loadPolicies(
      region: region,
      forceRefresh: true,
      isUserRefresh: true,
      page: 1,
      append: false,
    );
  }

  Future<void> loadNextPage() async {
    final region = (ref.read(regionProvider) ?? '').trim();
    final nextPage = state.page + 1;
    await _loadPolicies(
      region: region,
      forceRefresh: true,
      isUserRefresh: false,
      page: nextPage,
      append: true,
    );
  }

  Future<void> search(String query) async {
    final normalized = query.trim();
    _lastQuery = normalized.isEmpty ? null : normalized;
    debugPrint('[PolicyListNotifier] search() query="$normalized" lastQuery=$_lastQuery');

    if (_lastQuery != null) {
      await _historySource.saveQuery(_lastQuery!);
    }

    ref.invalidate(searchHistoryListProvider);
    await refresh();
  }

  void _debugLogState(String where) {
    if (!kDebugMode) return;
    debugPrint(
      '[PolicyListNotifier][$where] '
      'isLoading=${state.isLoading}, '
      'isRefreshing=${state.isRefreshing}, '
      'isLoadingMore=${state.isLoadingMore}, '
      'page=${state.page}, '
      'hasMore=${state.hasMore}, '
      'isStale=${state.isStale}, '
      'policies=${state.policies.length}, '
      'error=${state.error}',
    );
  }
}
