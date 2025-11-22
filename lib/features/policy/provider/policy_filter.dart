class PolicyFilter {
  const PolicyFilter({
    this.searchRgnSe,
    this.searchPolicyType,
    this.searchKeyword,
    this.yyyy,
    this.applyAbleFilter,
    this.pageIndex = 1,
    this.pageSize = 10,
  });

  final String? searchRgnSe;
  final String? searchPolicyType;
  final String? searchKeyword;
  final String? yyyy;
  final String? applyAbleFilter; // "Y" 등
  final int pageIndex;
  final int pageSize;

  PolicyFilter copyWith({
    String? searchRgnSe,
    String? searchPolicyType,
    String? searchKeyword,
    String? yyyy,
    String? applyAbleFilter,
    int? pageIndex,
    int? pageSize,
  }) {
    return PolicyFilter(
      searchRgnSe: searchRgnSe ?? this.searchRgnSe,
      searchPolicyType: searchPolicyType ?? this.searchPolicyType,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      yyyy: yyyy ?? this.yyyy,
      applyAbleFilter: applyAbleFilter ?? this.applyAbleFilter,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
