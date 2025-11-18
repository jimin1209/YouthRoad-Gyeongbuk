class PolicyRequestDto {
  const PolicyRequestDto({
    required this.apiKey,
    this.searchKeyword,
    this.searchPolicyType,
    this.searchRgnSe,
    this.searchPolicyStatus,
    this.searchAge,
    this.pageIndex,
    this.pageSize,
  });

  final String apiKey;
  final String? searchKeyword;
  final String? searchPolicyType;
  final String? searchRgnSe;
  final String? searchPolicyStatus;
  final int? searchAge;
  final int? pageIndex;
  final int? pageSize;

  Map<String, dynamic> toJson() => toQuery();

  Map<String, dynamic> toQuery() {
    final Map<String, String> query = {'apiKey': apiKey};
    void put(String key, Object? value) {
      if (value == null) {
        return;
      }
      final stringValue = value.toString();
      if (stringValue.isEmpty) {
        return;
      }
      query[key] = stringValue;
    }

    put('searchKeyword', searchKeyword);
    put('searchPolicyType', searchPolicyType);
    put('searchRgnSe', searchRgnSe);
    put('searchPolicyStatus', searchPolicyStatus);
    put('searchAge', searchAge);
    put('pageIndex', pageIndex);
    put('pageSize', pageSize);

    return query;
  }
}
