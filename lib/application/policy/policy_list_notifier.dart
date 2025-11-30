// FILE: lib/application/policy/policy_list_notifier.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/policy_filter.dart';
import '../../data/policy/policy_repository.dart';
import '../../data/sources/local/search_history_source.dart';
import '../../domain/entities/policy.dart';
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

  SwrPolicyRepository get _repo => ref.read(policyRepositoryProvider);

  SearchHistorySource get _historySource => ref.read(searchHistorySourceProvider);

  @override
  PolicyListState build() {
    _loadPolicies();
    return const PolicyListState(isLoading: true);
  }

  PolicyFilter _buildFilter() {
    final region = ref.watch(regionProvider);
    return PolicyFilter(
      searchRgnSe: region,
      searchText: _lastQuery,
      availableOnly: true,
    );
  }

  Future<void> _loadPolicies({bool forceRefresh = false}) async {
    final filter = _buildFilter();
    state = state.copyWith(isLoading: true, error: null, isStale: true);

    try {
      final result = await _repo.getPolicies(
        filter: filter,
        forceRefresh: forceRefresh,
      );

      state = state.copyWith(
        policies: result.policies,
        isLoading: false,
        isStale: true,
        error: null,
      );
      debugPrint(
          '[PolicyListNotifier] initial cache load done. count=${result.policies.length}');

      final remoteFuture = result.remoteRefresh;
      if (remoteFuture != null) {
        remoteFuture.then((latest) {
          state = state.copyWith(
            policies: latest,
            isStale: false,
            error: null,
          );
          debugPrint(
              '[PolicyListNotifier] remote refresh success. count=${latest.length}');
        }).catchError((error, stack) {
          debugPrint('[PolicyListNotifier] remote refresh failed: error=$error');
          debugPrint('$stack');
          state = state.copyWith(error: error, isStale: true);
        });
      }
    } catch (e, st) {
      debugPrint('[PolicyListNotifier] remote refresh failed: error=$e');
      debugPrint('$st');
      state = state.copyWith(
        isLoading: false,
        error: e,
        isStale: state.policies.isNotEmpty,
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, error: null);
    try {
      final policies = await _repo.refreshPolicies(
        filter: _buildFilter(),
      );
      state = state.copyWith(
        policies: policies,
        isRefreshing: false,
        isStale: false,
        error: null,
      );
      debugPrint(
          '[PolicyListNotifier] remote refresh success. count=${policies.length}');
    } catch (e, st) {
      debugPrint('[PolicyListNotifier] remote refresh failed: error=$e');
      debugPrint('$st');
      state = state.copyWith(
        isRefreshing: false,
        error: e,
        isStale: state.policies.isNotEmpty,
      );
    }
  }

  Future<void> search(String query) async {
    final normalized = query.trim();
    _lastQuery = normalized.isEmpty ? null : normalized;
    if (_lastQuery != null) {
      await _historySource.saveQuery(_lastQuery!);
    }
    ref.invalidate(searchHistoryListProvider);
    await refresh();
  }
}
