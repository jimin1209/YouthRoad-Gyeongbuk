// FILE: lib/application/policy/policy_list_notifier.dart
// 정책 리스트는 "UI 우선"을 지향한다. 첫 렌더링 시 로딩 스피너로 화면을 막지 않고
// 바로 화면을 그린 뒤, Isar 캐시를 즉시 반영하고 원격 데이터는 백그라운드에서
// 갱신하도록 설계했다.

import 'dart:async';

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

  PolicyRepository get _repo => ref.read(policyRepositoryInterfaceProvider);

  SearchHistorySource get _historySource => ref.read(searchHistorySourceProvider);

  @override
  PolicyListState build() {
    final region = ref.watch(regionProvider);
    final normalizedRegion = region?.trim() ?? '';
    debugPrint('[PolicyListNotifier] build() with region=$region');

    // 초기 state는 isLoading=false로 두어 첫 프레임을 즉시 렌더링한다.
    // 실제 로딩은 마이크로태스크로 밀어 UI 블로킹을 피한다.
    if (!_initialLoadScheduled) {
      _initialLoadScheduled = true;
      Future.microtask(() {
        debugPrint('[PolicyListNotifier] scheduling initial load');
        _loadPolicies(region: normalizedRegion);
      });
    }

    ref.listen<String?>(regionProvider, (previous, next) {
      if (previous == next) return;
      debugPrint(
        '[PolicyListNotifier] region changed: $previous -> $next, reloading policies',
      );
      _loadPolicies(region: (next ?? '').trim(), forceRefresh: false);
    });

    ref.onDispose(() {
      debugPrint('[PolicyListNotifier] disposed');
    });

    return const PolicyListState();
  }

  PolicyFilter _buildFilter({required String region}) {
    final normalizedRegion = region.trim();
    return PolicyFilter(
      searchRgnSe: normalizedRegion.isEmpty ? null : normalizedRegion,
      searchText: _lastQuery,
      availableOnly: true,
      pagingYn: 'N',
      recordCount: 2000,
    );
  }

  Future<void> _loadPolicies({
    required String region,
    bool forceRefresh = false,
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

    // isLoading=true로 표시하되 UI는 이미 그려진 상태이므로 블로킹되지 않는다.
    state = state.copyWith(
      isLoading: true,
      error: null,
      isStale: state.policies.isNotEmpty,
    );

    try {
      final filter = _buildFilter(region: region);
      final result = await _repo.getPolicies(
        filter: filter,
        forceRefresh: forceRefresh,
      );

      final remoteFuture = result.remoteRefresh;
      final shouldMarkStale = remoteFuture != null && result.policies.isNotEmpty;

      state = state.copyWith(
        policies: result.policies,
        isLoading: false,
        isRefreshing: false,
        isStale: shouldMarkStale,
        error: null,
      );
      debugPrint(
        '[PolicyListNotifier] cache load done. count=${result.policies.length}',
      );

      if (remoteFuture != null) {
        unawaited(
          remoteFuture.then((latest) {
            if (!mounted) return;
            state = state.copyWith(
              policies: latest,
              isStale: false,
              isRefreshing: false,
              error: null,
            );
            debugPrint(
              '[PolicyListNotifier] remote refresh success. count=${latest.length}',
            );
          }).catchError((error, stack) {
            if (!mounted) return;
            debugPrint('[PolicyListNotifier] remote refresh failed: error=$error');
            debugPrint('$stack');
            state = state.copyWith(
              error: error,
              isStale: false,
              isRefreshing: false,
            );
          }),
        );
      }
    } catch (e, st) {
      debugPrint('[PolicyListNotifier] remote refresh failed: error=$e');
      debugPrint('$st');
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: e,
        isStale: false,
      );
    }

    _debugLogState('after _loadPolicies');
  }

  Future<void> refresh() async {
    final region = (ref.read(regionProvider) ?? '').trim();
    debugPrint('[PolicyListNotifier] refresh() start with region=$region');

    state = state.copyWith(
      isRefreshing: true,
      error: null,
      isStale: state.policies.isNotEmpty,
    );

    try {
      final filter = _buildFilter(region: region);
      final result = await _repo.getPolicies(
        filter: filter,
        forceRefresh: true,
      );

      final remoteFuture = result.remoteRefresh;
      final shouldMarkStale = remoteFuture != null && result.policies.isNotEmpty;

      state = state.copyWith(
        policies: result.policies,
        isStale: shouldMarkStale,
        error: null,
      );

      if (remoteFuture != null) {
        unawaited(
          remoteFuture.then((latest) {
            if (!mounted) return;
            state = state.copyWith(
              policies: latest,
              isStale: false,
              isRefreshing: false,
              error: null,
            );
            debugPrint(
              '[PolicyListNotifier] refresh remote success. count=${latest.length}',
            );
          }).catchError((error, stack) {
            if (!mounted) return;
            debugPrint('[PolicyListNotifier] refresh remote failed: error=$error');
            debugPrint('$stack');
            state = state.copyWith(
              isRefreshing: false,
              error: error,
              isStale: false,
            );
          }),
        );
      } else {
        state = state.copyWith(
          isRefreshing: false,
          isStale: false,
        );
      }
    } catch (e, st) {
      debugPrint('[PolicyListNotifier] refresh failed: error=$e');
      debugPrint('$st');
      state = state.copyWith(
        isRefreshing: false,
        error: e,
        isStale: false,
      );
    }

    _debugLogState('after refresh');
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
