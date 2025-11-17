class PolicyRequestDto {
  const PolicyRequestDto({
    required this.apiKey,
    this.searchYear,
    this.searchPolicyNm,
    this.searchPolicyType,
    this.searchRgnSe,
    this.instNo,
    this.deptNo,
    this.pageIndex,
    this.recordCount,
    this.pageSize,
    this.pagingYn,
    this.searchDsplyYn,
  });

  final String apiKey;
  final String? searchYear;
  final String? searchPolicyNm;
  final String? searchPolicyType;
  final String? searchRgnSe;
  final String? instNo;
  final String? deptNo;
  final int? pageIndex;
  final int? recordCount;
  final int? pageSize;
  final String? pagingYn;
  final String? searchDsplyYn;

  Map<String, dynamic> toJson() => toQuery();

  Map<String, dynamic> toQuery() {
    final Map<String, String> query = {'apiKey': apiKey};
    void put(String key, String? value) {
      if (value != null && value.isNotEmpty) {
        query[key] = value;
      }
    }

    put('searchYear', searchYear);
    put('searchPolicyNm', searchPolicyNm);
    put('searchPolicyType', searchPolicyType);
    put('searchRgnSe', searchRgnSe);
    put('instNo', instNo);
    put('deptNo', deptNo);
    put('pageIndex', pageIndex?.toString());
    put('recordCount', recordCount?.toString());
    put('pageSize', pageSize?.toString());
    put('pagingYn', pagingYn);
    put('searchDsplyYn', searchDsplyYn);

    return query;
  }
}
