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

  /// 비어있는 문자열, '전체'와 같은 의미 없는 값들을 제거한 정상화된 필터를 반환한다.
  ///
  /// - 지역: '전체', '경북 전체' 등은 null 처리
  /// - 카테고리: '전체' 문자열은 제거
  /// - 검색어: searchText와 searchPolicyNm을 통합 후 trim
  /// - 페이징: pageIndex/recordCount를 안전한 범위로 보정하고 pagingYn 기본값을 지정
  PolicyFilter normalize() {
    final normalizedRegion = _normalizeRegion(searchRgnSe);
    final normalizedCategory = _normalizeCategory(searchPolicyType ?? category);
    final normalizedSearchText = _normalizeText(searchText ?? searchPolicyNm);

    final normalizedPageIndex = (pageIndex ?? 1).clamp(1, 9999);
    final normalizedRecordCount = (recordCount ??
            ((pagingYn ?? 'N').toUpperCase() == 'Y' ? 20 : 2000))
        .clamp(1, 2000);

    return PolicyFilter(
      searchRgnSe: normalizedRegion,
      searchPolicyType: normalizedCategory,
      searchPolicyNm: normalizedSearchText,
      searchText: normalizedSearchText,
      category: normalizedCategory,
      searchYear: _normalizeEmpty(searchYear),
      instNo: _normalizeEmpty(instNo),
      deptNo: _normalizeEmpty(deptNo),
      startDate: startDate,
      endDate: endDate,
      availableOnly: availableOnly,
      pageIndex: normalizedPageIndex,
      recordCount: normalizedRecordCount,
      pageSize: pageSize ?? normalizedRecordCount,
      pagingYn: (pagingYn ?? (normalizedPageIndex > 1 ? 'Y' : 'N')).toUpperCase(),
      searchDsplyYn: (searchDsplyYn?.isNotEmpty == true
              ? searchDsplyYn
              : 'all')
          ?.toLowerCase(),
    );
  }

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

  static String? _normalizeEmpty(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed == '전체') return null;
    return trimmed;
  }

  static String? _normalizeRegion(String? value) {
    final normalized = _normalizeEmpty(value);
    if (normalized == null) return null;

    const regionMap = {
      '경북 전체': null,
      '경북전체': null,
      '경북': '경상북도',
      '경상북도': '경상북도',
      '전체': null,
    };

    if (regionMap.containsKey(normalized)) {
      return regionMap[normalized];
    }

    return normalized;
  }

  static String? _normalizeCategory(String? value) {
    final normalized = _normalizeEmpty(value);
    if (normalized == null) return null;
    if (normalized.toLowerCase() == 'all') return null;
    return normalized;
  }

  static String? _normalizeText(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return trimmed;
  }
}
