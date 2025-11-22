import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/result.dart';
import '../data/policy_repository.dart';
import '../model/policy_item.dart';
import 'policy_filter.dart';

class PolicyListState {
  const PolicyListState({
    required this.items,
    required this.isLoading,
    required this.hasMore,
    required this.error,
    required this.filter,
  });

  final List<PolicyItem> items;
  final bool isLoading;
  final bool hasMore;
  final AppError? error;
  final PolicyFilter filter;

  PolicyListState copyWith({
    List<PolicyItem>? items,
    bool? isLoading,
    bool? hasMore,
    AppError? error,
    PolicyFilter? filter,
  }) {
    return PolicyListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      filter: filter ?? this.filter,
    );
  }

  factory PolicyListState.initial() => PolicyListState(
        items: const [],
        isLoading: false,
        hasMore: true,
        error: null,
        filter: const PolicyFilter(pageIndex: 1, pageSize: 10),
      );
}

class PolicyListNotifier extends StateNotifier<PolicyListState> {
  PolicyListNotifier(this._ref) : super(PolicyListState.initial());

  final Ref _ref;

  Future<void> refresh() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      items: const [],
      filter: state.filter.copyWith(pageIndex: 1),
    );
    await _fetch(append: false);
  }

  Future<void> fetchMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true);
    await _fetch(append: true);
  }

  Future<void> _fetch({required bool append}) async {
    final repo = _ref.read(policyRepositoryProvider);
    final Result<PolicyListResponse> result = await repo.fetchList(state.filter);
    result.when(
      success: (res) {
        final source = res.items.isNotEmpty ? res.items : (res.resultList ?? []);
        final List<PolicyItem> merged = append ? [...state.items, ...source] : source;
        final bool hasMore = source.length >= state.filter.pageSize;
        state = state.copyWith(
          items: merged,
          hasMore: hasMore,
          isLoading: false,
          error: null,
          filter: state.filter.copyWith(pageIndex: state.filter.pageIndex + 1),
        );
      },
      failure: (err) {
        state = state.copyWith(isLoading: false, error: err);
      },
    );
  }

  void setQuickFilter(String label) {
    final mappedKeyword = _mapQuickLabelToKeyword(label);
    state = state.copyWith(
      filter: state.filter.copyWith(
        searchPolicyType: null,
        searchKeyword: mappedKeyword,
        pageIndex: 1,
      ),
    );
    refresh();
  }

  void setSearchKeyword(String? keyword) {
    state = state.copyWith(
      filter: state.filter.copyWith(searchKeyword: keyword, pageIndex: 1),
    );
    refresh();
  }

  void setYear(String? year) {
    state = state.copyWith(
      filter: state.filter.copyWith(yyyy: year, pageIndex: 1),
    );
    refresh();
  }

  void toggleApplyAble(bool enabled) {
    state = state.copyWith(
      filter: state.filter.copyWith(applyAbleFilter: enabled ? 'Y' : null, pageIndex: 1),
    );
    refresh();
  }

  void setRegion(String? regionCode) {
    state = state.copyWith(
      filter: state.filter.copyWith(searchRgnSe: regionCode, pageIndex: 1),
    );
    refresh();
  }
}

String? _mapQuickLabelToKeyword(String label) {
  if (label == '전체') return null;
  return label;
}

final policyListProvider = StateNotifierProvider<PolicyListNotifier, PolicyListState>(
  (ref) => PolicyListNotifier(ref),
);
