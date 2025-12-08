import '../../domain/values/policy_sort.dart';
import '../../domain/values/policy_status_filter.dart';

class SearchLabelBuildContext {
  const SearchLabelBuildContext._();

  static String makeLabel(
    String regionName,
    String filterLabel,
    String sortLabel,
  ) {
    final parts = <String>[regionName];
    if (filterLabel.isNotEmpty) {
      parts.add(filterLabel);
    }
    if (sortLabel.isNotEmpty) {
      parts.add(sortLabel);
    }
    return parts.join(' · ');
  }

  static String filterLabelFromStatus(PolicyStatusFilter status) {
    switch (status) {
      case PolicyStatusFilter.inProgressOnly:
        return '진행중';
      case PolicyStatusFilter.includeClosed:
        return '마감 포함';
      case PolicyStatusFilter.closedOnly:
        return '마감된 정책';
    }
  }

  static String sortLabel(PolicySortOption sort) {
    switch (sort) {
      case PolicySortOption.latest:
        return '최신순';
      case PolicySortOption.deadline:
        return '마감 임박 우선순';
      case PolicySortOption.popularity:
        return '인기순';
      case PolicySortOption.recommendation:
        return '추천순';
    }
  }
}
