class PolicyFilter {
  const PolicyFilter({
    this.region,
    this.policyType,
    this.keyword,
    this.year,
    this.isAvailable,
    this.pageIndex,
    this.pageSize,
  });

  final String? region;
  final String? policyType;
  final String? keyword;
  final int? year;
  final bool? isAvailable;
  final int? pageIndex;
  final int? pageSize;

  PolicyFilter copyWith({
    String? region,
    String? policyType,
    String? keyword,
    int? year,
    bool? isAvailable,
    int? pageIndex,
    int? pageSize,
  }) {
    return PolicyFilter(
      region: region ?? this.region,
      policyType: policyType ?? this.policyType,
      keyword: keyword ?? this.keyword,
      year: year ?? this.year,
      isAvailable: isAvailable ?? this.isAvailable,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  factory PolicyFilter.fromJson(Map<String, dynamic> json) {
    return PolicyFilter(
      region: json['region'] as String?,
      policyType: json['policyType'] as String?,
      keyword: json['keyword'] as String?,
      year: (json['year'] as num?)?.toInt(),
      isAvailable: json['isAvailable'] as bool?,
      pageIndex: (json['pageIndex'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    void put(String key, dynamic value) {
      if (value != null) {
        data[key] = value;
      }
    }

    put('region', region);
    put('policyType', policyType);
    put('keyword', keyword);
    put('year', year);
    put('isAvailable', isAvailable);
    put('pageIndex', pageIndex);
    put('pageSize', pageSize);

    return data;
  }
}
