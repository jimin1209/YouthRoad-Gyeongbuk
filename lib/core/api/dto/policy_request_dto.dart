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

  static const int minPageSize = 1;
  static const int maxPageSize = 100;

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
    String? sanitizeString(String? value) {
      final trimmed = value?.trim();
      if (trimmed == null || trimmed.isEmpty) {
        return null;
      }
      return trimmed;
    }

    int? normalizePageIndex(int? value) {
      if (value == null) {
        return null;
      }
      return value < 1 ? 1 : value;
    }

    int? normalizePageSize(int? value) {
      if (value == null) {
        return null;
      }
      if (value < minPageSize) {
        return minPageSize;
      }
      if (value > maxPageSize) {
        return maxPageSize;
      }
      return value;
    }

    int? normalizeAge(int? value) {
      if (value == null || value <= 0) {
        return null;
      }
      return value;
    }

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
