class PolicySearchQuery {
  const PolicySearchQuery({
    this.keyword,
    this.region,
    this.organization,
    this.page = 1,
    this.pageSize = 10,
    this.cacheDuration,
  });

  final String? keyword;
  final String? region;
  final String? organization;
  final int page;
  final int pageSize;
  final Duration? cacheDuration;

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{
      'pageNum': page,
      'pageSize': pageSize,
    };

    void put(String key, String? value) {
      if (value != null && value.isNotEmpty) {
        params[key] = value;
      }
    }

    put('keyword', keyword);
    put('region', region);
    put('organization', organization);
    return params;
  }

  PolicySearchQuery copyWith({
    String? keyword,
    String? region,
    String? organization,
    int? page,
    int? pageSize,
    Duration? cacheDuration,
  }) {
    return PolicySearchQuery(
      keyword: keyword ?? this.keyword,
      region: region ?? this.region,
      organization: organization ?? this.organization,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      cacheDuration: cacheDuration ?? this.cacheDuration,
    );
  }
}
