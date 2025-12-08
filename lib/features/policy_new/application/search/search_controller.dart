import '../../domain/values/policy_filter.dart';
import '../../domain/values/policy_sort.dart';
import '../../domain/values/policy_status_filter.dart';

class PolicySearchController {
  const PolicySearchController();

  /// 검색 캐시 키를 표준 형태로 생성한다.
  ///
  /// key format: `search:{regionCode}:{filterCode}:{orderCode}`
  String buildCacheKey({
    required PolicyFilter filter,
    required PolicySortOption sort,
  }) {
    final regionCode = _regionCode(filter);
    final filterCode = _filterCode(filter.status);
    final orderCode = sort.name;
    return 'search:$regionCode:$filterCode:$orderCode';
  }

  PolicyStatusFilter mapStatusFromChip(PolicyStatusFilter selected) {
    switch (selected) {
      case PolicyStatusFilter.inProgressOnly:
        return PolicyStatusFilter.inProgressOnly;
      case PolicyStatusFilter.closedOnly:
        return PolicyStatusFilter.closedOnly;
      case PolicyStatusFilter.includeClosed:
        return PolicyStatusFilter.includeClosed;
    }
  }

  String _regionCode(PolicyFilter filter) {
    final buffer = StringBuffer(filter.region.name);
    if (filter.province.isNotEmpty) buffer.write('-${filter.province}');
    if (filter.city != null && filter.city!.isNotEmpty) {
      buffer.write('-${filter.city}');
    }
    if (filter.district != null && filter.district!.isNotEmpty) {
      buffer.write('-${filter.district}');
    }
    return buffer.toString();
  }

  String _filterCode(PolicyStatusFilter status) {
    switch (status) {
      case PolicyStatusFilter.inProgressOnly:
        return 'active';
      case PolicyStatusFilter.includeClosed:
        return 'all';
      case PolicyStatusFilter.closedOnly:
        return 'closed';
    }
  }
}
