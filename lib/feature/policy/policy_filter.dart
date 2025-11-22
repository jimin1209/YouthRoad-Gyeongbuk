class PolicyFilter {
  const PolicyFilter({
    this.searchYear,
    this.searchPolicyNm,
    this.policyTypes = const <String>[],
    this.regionCodes = const <String>[],
    this.instNo,
    this.deptNo,
    this.onlyAvailable = false,
    this.pageIndex = 1,
    this.recordCount = 10,
    this.pageSize = 10,
    this.pagingYn = 'Y',
    this.searchDsplyYn,
  });

  final String? searchYear;
  final String? searchPolicyNm;
  final List<String> policyTypes;
  final List<String> regionCodes;
  final String? instNo;
  final String? deptNo;
  final bool onlyAvailable;
  final int pageIndex;
  final int recordCount;
  final int pageSize;
  final String? pagingYn;
  final String? searchDsplyYn;

  PolicyFilter copyWith({
    String? searchYear,
    String? searchPolicyNm,
    List<String>? policyTypes,
    List<String>? regionCodes,
    String? instNo,
    String? deptNo,
    bool? onlyAvailable,
    int? pageIndex,
    int? recordCount,
    int? pageSize,
    String? pagingYn,
    String? searchDsplyYn,
  }) {
    return PolicyFilter(
      searchYear: searchYear ?? this.searchYear,
      searchPolicyNm: searchPolicyNm ?? this.searchPolicyNm,
      policyTypes: policyTypes ?? this.policyTypes,
      regionCodes: regionCodes ?? this.regionCodes,
      instNo: instNo ?? this.instNo,
      deptNo: deptNo ?? this.deptNo,
      onlyAvailable: onlyAvailable ?? this.onlyAvailable,
      pageIndex: pageIndex ?? this.pageIndex,
      recordCount: recordCount ?? this.recordCount,
      pageSize: pageSize ?? this.pageSize,
      pagingYn: pagingYn ?? this.pagingYn,
      searchDsplyYn: searchDsplyYn ?? this.searchDsplyYn,
    );
  }
}
