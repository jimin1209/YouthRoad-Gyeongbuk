class PolicyFilter {
  const PolicyFilter({
    this.searchRgnSe,
    this.searchPolicyType,
    this.searchPolicyNm,
    this.searchText,
    this.category,
    this.searchYear,
    this.instNo,
    this.deptNo,
    this.startDate,
    this.endDate,
    this.availableOnly,
    this.pageSize,
    int? pageIndex,
    int? recordCount,
    String? pagingYn,
    String? searchDsplyYn,
  })
      : pageIndex = pageIndex ?? 1,
        recordCount = recordCount ?? 2000,
        pagingYn = pagingYn ?? 'N',
        searchDsplyYn = searchDsplyYn ?? 'all';

  final String? searchRgnSe;
  final String? searchPolicyType;
  final String? searchPolicyNm;
  final String? searchText;
  final String? category;
  final String? searchYear;
  final String? instNo;
  final String? deptNo;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? availableOnly;
  final int? pageIndex;
  final int? recordCount;
  final int? pageSize;
  final String? pagingYn;
  final String? searchDsplyYn;

  PolicyFilter copyWith({
    String? searchRgnSe,
    String? searchPolicyType,
    String? searchPolicyNm,
    String? searchText,
    String? category,
    String? searchYear,
    String? instNo,
    String? deptNo,
    DateTime? startDate,
    DateTime? endDate,
    bool? availableOnly,
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
      searchText: searchText ?? this.searchText,
      category: category ?? this.category,
      searchYear: searchYear ?? this.searchYear,
      instNo: instNo ?? this.instNo,
      deptNo: deptNo ?? this.deptNo,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      availableOnly: availableOnly ?? this.availableOnly,
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
      searchText: json['searchText'] as String?,
      category: json['category'] as String?,
      searchYear: json['searchYear'] as String?,
      instNo: json['instNo'] as String?,
      deptNo: json['deptNo'] as String?,
      startDate: _parseDate(json['startDate'] as String?),
      endDate: _parseDate(json['endDate'] as String?),
      availableOnly: json['availableOnly'] as bool?,
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
    put('searchText', searchText);
    put('category', category);
    put('searchYear', searchYear);
    put('instNo', instNo);
    put('deptNo', deptNo);
    put('startDate', _formatDate(startDate));
    put('endDate', _formatDate(endDate));
    put('availableOnly', availableOnly);
    put('pageIndex', pageIndex);
    put('recordCount', recordCount);
    put('pageSize', pageSize);
    put('pagingYn', pagingYn);
    put('searchDsplyYn', searchDsplyYn);

    return data;
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return date.toIso8601String();
  }
}
