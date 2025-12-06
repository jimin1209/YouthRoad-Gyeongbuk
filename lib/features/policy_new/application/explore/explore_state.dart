enum ExploreSubMode { all, region, search }

enum PolicyStatusFilter {
  inProgressOnly,
  includeClosed,
  closedOnly,
}

enum PolicySortKind {
  recommended,
  newest,
  deadline,
  amount,
}

class ExploreState {
  const ExploreState({
    this.mode = ExploreSubMode.all,
    this.keyword = '',
    this.selectedRegionName,
    this.selectedRegionCode,
    this.useMyRegionAsDefault = false,
    this.statusFilter = PolicyStatusFilter.inProgressOnly,
    this.sortKind = PolicySortKind.recommended,
    this.selectedCategories = const [],
    this.selectedSupportTypes = const [],
  });

  final ExploreSubMode mode;
  final String keyword;
  final String? selectedRegionName;
  final String? selectedRegionCode;
  final bool useMyRegionAsDefault;
  final PolicyStatusFilter statusFilter;
  final PolicySortKind sortKind;
  final List<String> selectedCategories;
  final List<String> selectedSupportTypes;

  bool get hasKeyword => keyword.isNotEmpty;
  bool get hasRegion => selectedRegionName != null && selectedRegionName!.isNotEmpty;

  ExploreState copyWith({
    ExploreSubMode? mode,
    String? keyword,
    String? selectedRegionName,
    String? selectedRegionCode,
    bool? useMyRegionAsDefault,
    PolicyStatusFilter? statusFilter,
    PolicySortKind? sortKind,
    List<String>? selectedCategories,
    List<String>? selectedSupportTypes,
  }) {
    return ExploreState(
      mode: mode ?? this.mode,
      keyword: keyword ?? this.keyword,
      selectedRegionName: selectedRegionName ?? this.selectedRegionName,
      selectedRegionCode: selectedRegionCode ?? this.selectedRegionCode,
      useMyRegionAsDefault: useMyRegionAsDefault ?? this.useMyRegionAsDefault,
      statusFilter: statusFilter ?? this.statusFilter,
      sortKind: sortKind ?? this.sortKind,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedSupportTypes: selectedSupportTypes ?? this.selectedSupportTypes,
    );
  }
}
