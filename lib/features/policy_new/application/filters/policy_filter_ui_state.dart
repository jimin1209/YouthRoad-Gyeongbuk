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
  final String? institutionId;
  final String? institutionName;
  final String? departmentId;
  final String? departmentName;

  const PolicyFilterUiState({
    this.region = PolicyRegion.all,
    this.category,
    this.sort = PolicySortOption.latest,
    this.keyword = '',
    this.tags = const [],
    this.showOnlyOnline = false,
    this.showOnlyOngoing = false,
    this.institutionId,
    this.institutionName,
    this.departmentId,
    this.departmentName,
  });

  PolicyFilterUiState copyWith({
    PolicyRegion? region,
    PolicyCategory? category,
    PolicySortOption? sort,
    String? keyword,
    List<String>? tags,
    bool? showOnlyOnline,
    bool? showOnlyOngoing,
    String? institutionId,
    String? institutionName,
    String? departmentId,
    String? departmentName,
  }) {
    return PolicyFilterUiState(
      region: region ?? this.region,
      category: category ?? this.category,
      sort: sort ?? this.sort,
      keyword: keyword ?? this.keyword,
      tags: tags ?? this.tags,
      showOnlyOnline: showOnlyOnline ?? this.showOnlyOnline,
      showOnlyOngoing: showOnlyOngoing ?? this.showOnlyOngoing,
      institutionId: institutionId ?? this.institutionId,
      institutionName: institutionName ?? this.institutionName,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
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

  void setInstitution({String? id, String? name}) => state = state.copyWith(
        institutionId: id,
        institutionName: name,
        departmentId: null,
        departmentName: null,
      );

  void setDepartment({String? id, String? name}) => state = state.copyWith(
        departmentId: id,
        departmentName: name,
      );

  void resetAll() => state = const PolicyFilterUiState();
}

final policyFilterUiStateProvider =
    StateNotifierProvider<PolicyFilterUiStateNotifier, PolicyFilterUiState>(
  (ref) => PolicyFilterUiStateNotifier(),
);
