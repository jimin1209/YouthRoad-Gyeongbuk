enum PolicyStatusFilter {
  includeClosed,
  inProgressOnly,
  closedOnly;

  /// UI 노출 및 선택 순서를 고정하기 위한 리스트
  static const List<PolicyStatusFilter> uiOptions = [
    PolicyStatusFilter.includeClosed,
    PolicyStatusFilter.inProgressOnly,
    PolicyStatusFilter.closedOnly,
  ];
}

extension PolicyStatusFilterX on PolicyStatusFilter {
  static PolicyStatusFilter fromQueryValue(String? value) {
    final normalized = value?.trim().toLowerCase();
    switch (normalized) {
      case 'active':
        return PolicyStatusFilter.inProgressOnly;
      case 'closed':
        return PolicyStatusFilter.closedOnly;
      case 'any':
      case null:
      case 'all':
      default:
        return PolicyStatusFilter.includeClosed;
    }
  }

  /// API 및 캐시 키에 사용되는 쿼리 값 매핑
  String get queryValue {
    switch (this) {
      case PolicyStatusFilter.includeClosed:
        return 'all';
      case PolicyStatusFilter.inProgressOnly:
        return 'active';
      case PolicyStatusFilter.closedOnly:
        return 'closed';
    }
  }

  /// UI 라벨 (칩/옵션에 사용)
  String get uiLabel {
    switch (this) {
      case PolicyStatusFilter.includeClosed:
        return '전체';
      case PolicyStatusFilter.inProgressOnly:
        return '진행중';
      case PolicyStatusFilter.closedOnly:
        return '마감';
    }
  }

  /// 요약 영역 라벨
  String get summaryLabel {
    switch (this) {
      case PolicyStatusFilter.includeClosed:
        return '전체 정책';
      case PolicyStatusFilter.inProgressOnly:
        return '진행중 정책만';
      case PolicyStatusFilter.closedOnly:
        return '마감된 정책만';
    }
  }
}
