// FILE: lib/application/policy/policy_list_notifier.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/policy_filter.dart';
import '../../data/sources/local/search_history_source.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../di.dart';
import '../notifiers/region_notifier.dart';

class PolicyListState {
  const PolicyListState({
    this.policies = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.isStale = false,
  });

  final List<Policy> policies;
  final bool isLoading;
  final bool isRefreshing;
  final Object? error;
  final bool isStale;

  PolicyListState copyWith({
    List<Policy>? policies,
    bool? isLoading,
    bool? isRefreshing,
    Object? error = _noUpdate,
    bool? isStale,
  }) {
    return PolicyListState(
      policies: policies ?? this.policies,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
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
      );
    });

    ref.onDispose(() {
      debugPrint('[PolicyListNotifier] disposed');
    });

    return const PolicyListState(isLoading: true);
  }

  PolicyFilter _buildFilter({required String region}) {
    final normalizedRegion = region.trim();
    return PolicyFilter(
      searchRgnSe: normalizedRegion.isEmpty ? null : normalizedRegion,
      searchText: _lastQuery,
      availableOnly: true,
    );
  }

  int _nextRequestId() => ++_requestCounter;

  bool _isLatestRequest(int requestId) => requestId == _requestCounter;

  Future<void> _loadPolicies({
    required String region,
    required bool forceRefresh,
    required bool isUserRefresh,
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
    final previousPolicies = state.policies;
    final normalizedRegion = region.trim();

    debugPrint(
      '[PolicyListNotifier][#$requestId] load start | '
      'region="$normalizedRegion" forceRefresh=$forceRefresh refresh=$isUserRefresh '
      'prevPolicies=${previousPolicies.length}',
    );

    state = state.copyWith(
      isLoading: isUserRefresh ? state.isLoading : true,
      isRefreshing: isUserRefresh,
      error: null,
      isStale: previousPolicies.isNotEmpty,
    );

    try {
      final filter = _buildFilter(region: normalizedRegion);
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
        isStale: shouldMarkStale,
        error: null,
      );
      debugPrint(
        '[PolicyListNotifier][#$requestId] cache applied: '
        'count=${policiesToApply.length} stale=$shouldMarkStale '
        'keptPrevious=$shouldKeepPrevious',
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
          error: null,
        );
        debugPrint(
          '[PolicyListNotifier][#$requestId] remote refresh success. count=${latest.length}',
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
        );
      });
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
        error: e,
        isStale: false,
      );
    }

    _debugLogState('after _loadPolicies #$requestId');
  }

  Future<void> refresh() async {
    final region = (ref.read(regionProvider) ?? '').trim();
    debugPrint('[PolicyListNotifier] refresh() start with region=$region');

    await _loadPolicies(region: region, forceRefresh: true, isUserRefresh: true);
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
      'isStale=${state.isStale}, '
      'policies=${state.policies.length}, '
      'error=${state.error}',
    );
  }
}
