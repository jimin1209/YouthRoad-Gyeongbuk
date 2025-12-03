import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_region.dart';
import '../../domain/values/policy_sort.dart';

@immutable
class PolicyFilterUiState {
  final PolicyRegion region;
  final PolicyCategory? category;
  final PolicySortOption sort;
  final String keyword;
  final List<String> tags;
  final bool showOnlyOnline;
  final bool showOnlyOngoing;

  const PolicyFilterUiState({
    this.region = PolicyRegion.all,
    this.category,
    this.sort = PolicySortOption.latest,
    this.keyword = '',
    this.tags = const [],
    this.showOnlyOnline = false,
    this.showOnlyOngoing = false,
  });

  PolicyFilterUiState copyWith({
    PolicyRegion? region,
    PolicyCategory? category,
    PolicySortOption? sort,
    String? keyword,
    List<String>? tags,
    bool? showOnlyOnline,
    bool? showOnlyOngoing,
  }) {
    return PolicyFilterUiState(
      region: region ?? this.region,
      category: category ?? this.category,
      sort: sort ?? this.sort,
      keyword: keyword ?? this.keyword,
      tags: tags ?? this.tags,
      showOnlyOnline: showOnlyOnline ?? this.showOnlyOnline,
      showOnlyOngoing: showOnlyOngoing ?? this.showOnlyOngoing,
    );
  }
}

class PolicyFilterUiStateNotifier extends StateNotifier<PolicyFilterUiState> {
  PolicyFilterUiStateNotifier() : super(const PolicyFilterUiState());

  void setRegion(PolicyRegion region) =>
      state = state.copyWith(region: region);

  void setCategory(PolicyCategory? category) =>
      state = state.copyWith(category: category);

  void setSort(PolicySortOption sort) => state = state.copyWith(sort: sort);

  void setKeyword(String keyword) =>
      state = state.copyWith(keyword: keyword);

  void setTags(List<String> tags) => state = state.copyWith(tags: tags);

  void toggleOnlineOnly() =>
      state = state.copyWith(showOnlyOnline: !state.showOnlyOnline);

  void toggleOngoingOnly() =>
      state = state.copyWith(showOnlyOngoing: !state.showOnlyOngoing);

  void resetAll() => state = const PolicyFilterUiState();
}

final policyFilterUiStateProvider =
    StateNotifierProvider<PolicyFilterUiStateNotifier, PolicyFilterUiState>(
  (ref) => PolicyFilterUiStateNotifier(),
);
