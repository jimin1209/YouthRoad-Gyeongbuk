import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_region.dart';
import '../../domain/values/policy_sort.dart';

@immutable
class PolicyFilterUiState {
  final PolicyRegion region;
  final String province;
  final String? city;
  final String? district;
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
    this.region = PolicyRegion.gyeongbuk,
    this.province = '경상북도',
    this.city,
    this.district,
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
    String? province,
    String? city,
    String? district,
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
      province: province ?? this.province,
      city: city ?? this.city,
      district: district ?? this.district,
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

  String get regionSummary {
    final cityName = city;
    final districtName = district;
    if (cityName == null || cityName.isEmpty) return '경북 전체';
    if (districtName == null || districtName.isEmpty) return '경북 $cityName';
    return '경북 $cityName $districtName';
  }
}

class PolicyFilterUiStateNotifier extends StateNotifier<PolicyFilterUiState> {
  PolicyFilterUiStateNotifier() : super(const PolicyFilterUiState());

  void setRegion(PolicyRegion region) =>
      state = state.copyWith(region: region);

  void setRegionStrings({
    required String province,
    String? city,
    String? district,
  }) {
    state = state.copyWith(
      region: PolicyRegion.gyeongbuk,
      province: province,
      city: city,
      district: district,
    );
  }

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
