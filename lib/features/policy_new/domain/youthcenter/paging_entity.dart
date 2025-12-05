class PagingEntity {
  const PagingEntity({
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });

  final int totalCount;
  final int pageNumber;
  final int pageSize;

  factory PagingEntity.empty() => const PagingEntity(
        totalCount: 0,
        pageNumber: 1,
        pageSize: 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }

  factory PagingEntity.fromJson(Map<String, dynamic> json) {
    return PagingEntity(
      totalCount: json['totalCount'] as int? ?? 0,
      pageNumber: json['pageNumber'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 0,
    );
  }
}
