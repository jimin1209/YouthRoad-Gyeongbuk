class PaginationInfo {
  const PaginationInfo({
    this.pageIndex,
    this.pageSize,
    this.totalCount,
    this.totalPageCount,
  });

  final int? pageIndex;
  final int? pageSize;
  final int? totalCount;
  final int? totalPageCount;

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      pageIndex: _asInt(json['pageIndex']) ?? _asInt(json['currentPage']),
      pageSize: _asInt(json['pageSize']) ?? _asInt(json['recordCount']),
      totalCount: _asInt(json['totalCount']) ?? _asInt(json['totalRecords']),
      totalPageCount:
          _asInt(json['totalPageCount']) ?? _asInt(json['totalPages']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'totalCount': totalCount,
      'totalPageCount': totalPageCount,
    };
  }
}

int? _asInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value.toString());
}
