class PolicyFilter {
  const PolicyFilter({
    this.searchRgnSe,
    this.searchPolicyType,
    this.searchPolicyNm,
    this.searchYear,
    this.instNo,
    this.deptNo,
    this.pageIndex,
    this.recordCount,
    this.pageSize,
    this.pagingYn,
    this.searchDsplyYn,
  });

  final String? searchRgnSe;
  final String? searchPolicyType;
  final String? searchPolicyNm;
  final String? searchYear;
  final String? instNo;
  final String? deptNo;
  final int? pageIndex;
  final int? recordCount;
  final int? pageSize;
  final String? pagingYn;
  final String? searchDsplyYn;

  PolicyFilter copyWith({
    String? searchRgnSe,
    String? searchPolicyType,
    String? searchPolicyNm,
    String? searchYear,
    String? instNo,
    String? deptNo,
    int? pageIndex,
    int? recordCount,
    int? pageSize,
    String? pagingYn,
    String? searchDsplyYn,
  }) {
    return PolicyFilter(
      searchRgnSe: searchRgnSe ?? this.searchRgnSe,
      searchPolicyType: searchPolicyType ?? this.searchPolicyType,
      searchPolicyNm: searchPolicyNm ?? this.searchPolicyNm,
      searchYear: searchYear ?? this.searchYear,
      instNo: instNo ?? this.instNo,
      deptNo: deptNo ?? this.deptNo,
      pageIndex: pageIndex ?? this.pageIndex,
      recordCount: recordCount ?? this.recordCount,
      pageSize: pageSize ?? this.pageSize,
      pagingYn: pagingYn ?? this.pagingYn,
      searchDsplyYn: searchDsplyYn ?? this.searchDsplyYn,
    );
  }

  factory PolicyFilter.fromJson(Map<String, dynamic> json) {
    return PolicyFilter(
      searchRgnSe: json['searchRgnSe'] as String?,
      searchPolicyType: json['searchPolicyType'] as String?,
      searchPolicyNm: json['searchPolicyNm'] as String?,
      searchYear: json['searchYear'] as String?,
      instNo: json['instNo'] as String?,
      deptNo: json['deptNo'] as String?,
      pageIndex: (json['pageIndex'] as num?)?.toInt(),
      recordCount: (json['recordCount'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      pagingYn: json['pagingYn'] as String?,
      searchDsplyYn: json['searchDsplyYn'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    void put(String key, dynamic value) {
      if (value != null) {
        data[key] = value;
      }
    }

    put('searchRgnSe', searchRgnSe);
    put('searchPolicyType', searchPolicyType);
    put('searchPolicyNm', searchPolicyNm);
    put('searchYear', searchYear);
    put('instNo', instNo);
    put('deptNo', deptNo);
    put('pageIndex', pageIndex);
    put('recordCount', recordCount);
    put('pageSize', pageSize);
    put('pagingYn', pagingYn);
    put('searchDsplyYn', searchDsplyYn);

    return data;
  }
}
