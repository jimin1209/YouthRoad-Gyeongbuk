import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_region.dart';
import '../../domain/values/policy_sort.dart';
import '../../domain/values/policy_status_filter.dart';
import '../reexplore/policy_reexplore.dart';
import '../../../../application/notifiers/region_notifier.dart';

@immutable
class PolicyFilterUiState {
  final PolicyRegion region;
  final String province;
  final String? city;
  final String? district;
  final PolicyCategory? category;
  final PolicySortOption sort;
  final List<String> tags;
  final PolicyStatusFilter status;
  final bool showOnlyOnline;
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
    this.tags = const [],
    this.status = PolicyStatusFilter.includeClosed,
    this.showOnlyOnline = false,
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
    List<String>? tags,
    PolicyStatusFilter? status,
    bool? showOnlyOnline,
    String? institutionId,
    String? institutionName,
    String? departmentId,
    String? departmentName,
  }) {
    final nextTags = tags != null
        ? List<String>.unmodifiable(tags)
        : List<String>.unmodifiable(this.tags);

    return PolicyFilterUiState(
      region: region ?? this.region,
      province: province ?? this.province,
      city: city ?? this.city,
      district: district ?? this.district,
      category: category ?? this.category,
      sort: sort ?? this.sort,
      tags: nextTags,
      status: status ?? this.status,
      showOnlyOnline: showOnlyOnline ?? this.showOnlyOnline,
      institutionId: institutionId ?? this.institutionId,
      institutionName: institutionName ?? this.institutionName,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
    );
  }

  String get regionSummary {
    if (region == PolicyRegion.all) return '전체';

    final provinceLabel = _provinceLabel(region, province);

    if (region != PolicyRegion.gyeongbuk) {
      return provinceLabel;
    }

    final cityName = city?.trim();
    final districtName = district?.trim();

    if (cityName == null || cityName.isEmpty) return '$provinceLabel 전체';
    if (districtName == null || districtName.isEmpty) {
      return '$provinceLabel $cityName';
    }
    return '$provinceLabel $cityName $districtName';
  }

}

class PolicyFilterUiStateNotifier extends StateNotifier<PolicyFilterUiState> {
  PolicyFilterUiStateNotifier({
    PolicyFilterUiState initialState = const PolicyFilterUiState(),
  }) : super(initialState);

  void setRegion(PolicyRegion region) => state = state.copyWith(
        region: region,
        province: _provinceName(region),
        city: region == PolicyRegion.gyeongbuk ? state.city : null,
        district: region == PolicyRegion.gyeongbuk ? state.district : null,
      );

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

  void setTags(List<String> tags) => state = state.copyWith(tags: tags);

  void toggleOnlineOnly() =>
      state = state.copyWith(showOnlyOnline: !state.showOnlyOnline);

  void setStatus(PolicyStatusFilter status) => state = state.copyWith(
        status: status,
      );

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

  PolicyFilterUiState applyFromDetail(
    Policy policy,
    PolicyReExploreMode mode,
    PolicyFilterUiState Function(PolicyFilterUiState, Policy, PolicyReExploreMode)
        builder,
  ) {
    final next = builder(state, policy, mode);
    state = next;
    return next;
  }
}

final globalFilterProvider =
    StateNotifierProvider<PolicyFilterUiStateNotifier, PolicyFilterUiState>(
  (ref) {
    final regionNotifier = ref.read(regionProvider.notifier);
    final notifier = PolicyFilterUiStateNotifier(
      initialState: PolicyFilterUiState(
        region: PolicyRegion.gyeongbuk,
        province: regionNotifier.selectedProvince,
        city: regionNotifier.selectedCity,
        district: regionNotifier.selectedDistrict,
      ),
    );

    final regionSubscription = ref.listen<String?>(
      regionProvider,
      (previous, next) {
        notifier.setRegionStrings(
          province: regionNotifier.selectedProvince,
          city: regionNotifier.selectedCity,
          district: regionNotifier.selectedDistrict,
        );
      },
      fireImmediately: false,
    );

    ref.onDispose(regionSubscription.close);

    return notifier;
  },
);

@Deprecated('Use globalFilterProvider instead')
final policyFilterUiStateProvider = globalFilterProvider;

String _provinceLabel(PolicyRegion region, String fallback) {
  switch (region) {
    case PolicyRegion.all:
      return '전국';
    case PolicyRegion.seoul:
      return '서울';
    case PolicyRegion.busan:
      return '부산';
    case PolicyRegion.daegu:
      return '대구';
    case PolicyRegion.incheon:
      return '인천';
    case PolicyRegion.gwangju:
      return '광주';
    case PolicyRegion.daejeon:
      return '대전';
    case PolicyRegion.ulsan:
      return '울산';
    case PolicyRegion.gyeongbuk:
      return '경북';
  }
  // ignore: dead_code
  return fallback.isEmpty ? '전체' : fallback;
}

String _provinceName(PolicyRegion region) {
  switch (region) {
    case PolicyRegion.all:
      return '전국';
    case PolicyRegion.seoul:
      return '서울';
    case PolicyRegion.busan:
      return '부산';
    case PolicyRegion.daegu:
      return '대구';
    case PolicyRegion.incheon:
      return '인천';
    case PolicyRegion.gwangju:
      return '광주';
    case PolicyRegion.daejeon:
      return '대전';
    case PolicyRegion.ulsan:
      return '울산';
    case PolicyRegion.gyeongbuk:
      return '경상북도';
  }
}
