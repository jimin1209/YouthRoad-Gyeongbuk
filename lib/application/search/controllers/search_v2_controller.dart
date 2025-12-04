import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/policy_filter.dart';
import '../../../data/sources/local/search_history_source.dart';
import '../../providers.dart';
import '../providers.dart';
import 'package:youth_road_app/legacy/policy/application/notifiers/policy_paging_notifier.dart';

class SearchV2State {
  const SearchV2State({
    this.initialization = const AsyncData<void>(null),
    this.hasInitialized = false,
    this.lastFilter,
    this.lastRequestKey,
    this.lastUpdated,
  });

  final AsyncValue<void> initialization;
  final bool hasInitialized;
  final PolicyFilter? lastFilter;
  final String? lastRequestKey;
  final DateTime? lastUpdated;

  bool get isInitializing => initialization.isLoading;
  String? get errorMessage => initialization.whenOrNull(
        data: (_) => null,
        error: (error, __) => error.toString(),
      );

  SearchV2State copyWith({
    AsyncValue<void>? initialization,
    bool? hasInitialized,
    PolicyFilter? lastFilter,
    String? lastRequestKey,
    DateTime? lastUpdated,
  }) {
    return SearchV2State(
      initialization: initialization ?? this.initialization,
      hasInitialized: hasInitialized ?? this.hasInitialized,
      lastFilter: lastFilter ?? this.lastFilter,
      lastRequestKey: lastRequestKey ?? this.lastRequestKey,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class SearchV2Controller extends AutoDisposeNotifier<SearchV2State> {
  @override
  SearchV2State build() {
    ref.onDispose(() {});
    return const SearchV2State();
  }

  PolicyFilter _defaultFilter() {
    final region = ref.read(regionProvider);
    return PolicyFilter(
      searchRgnSe: region,
      availableOnly: true,
      pageIndex: 1,
      recordCount: 10,
      pagingYn: 'Y',
    ).normalize();
  }

  String _buildRequestKey(PolicyFilter filter) {
    final normalized = filter
        .copyWith(
          pageIndex: 1,
          recordCount: filter.recordCount ?? 10,
          pagingYn: filter.pagingYn ?? 'Y',
        )
        .normalize();

    return jsonEncode(normalized.toJson());
  }

  Future<void> initialize([PolicyFilter? filter]) async {
    final targetFilter = (filter ?? _defaultFilter()).normalize();
    final nextKey = _buildRequestKey(targetFilter);
    if (state.isInitializing && state.lastRequestKey == nextKey) return;

    state = state.copyWith(
      initialization: const AsyncLoading<void>(),
      hasInitialized: state.hasInitialized,
      lastFilter: targetFilter,
      lastRequestKey: nextKey,
    );

    final feedsNotifier = ref.read(policyPagingProvider.notifier);

    final result = await AsyncValue.guard(() async {
      await Future.wait([
        feedsNotifier.refreshAll(targetFilter),
        ref.refresh(searchHistoryListProvider.future),
        ref.refresh(popularSearchKeywordListProvider.future),
      ]);
    });

    if (result.hasError) {
      state = state.copyWith(
        initialization: result,
        hasInitialized: state.hasInitialized,
        lastFilter: targetFilter,
        lastRequestKey: nextKey,
      );
      return;
    }

    state = state.copyWith(
      initialization: const AsyncData<void>(null),
      hasInitialized: true,
      lastFilter: targetFilter,
      lastRequestKey: nextKey,
      lastUpdated: DateTime.now(),
    );
  }

  Future<void> applyFilter(PolicyFilter filter) async {
    await initialize(filter);
  }

  Future<void> retry() async {
    final filter = state.lastFilter ?? _defaultFilter();
    await initialize(filter);
  }
}
