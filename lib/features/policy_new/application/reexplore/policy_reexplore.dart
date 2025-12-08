import '../../domain/entities/policy.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_filter.dart';
import '../../domain/values/policy_query.dart';
import '../../domain/values/policy_sort.dart';
import '../filters/policy_filter_summary.dart';
import '../filters/policy_filter_ui_state.dart';
import '../controllers/policy_query_state.dart';

enum PolicyReExploreMode {
  similar,
  institution,
  category,
}

class PolicyReExploreBuilder {
  static PolicyFilterUiState buildFilter(
    PolicyFilterUiState _,
    Policy policy,
    PolicyReExploreMode mode,
  ) {
    final tags = _primaryTags(policy);

    switch (mode) {
      case PolicyReExploreMode.similar:
        return PolicyFilterUiState(
          region: policy.region,
          category: policy.category,
          tags: tags,
          sort: PolicySortOption.recommendation,
        );
      case PolicyReExploreMode.institution:
        return PolicyFilterUiState(
          region: policy.region,
          sort: PolicySortOption.latest,
          institutionId: policy.institutionId,
          institutionName: policy.institution,
          departmentId: policy.departmentId,
          departmentName: policy.department,
        );
      case PolicyReExploreMode.category:
        return PolicyFilterUiState(
          region: policy.region,
          category: policy.category,
          sort: PolicySortOption.latest,
        );
    }
  }

  static PolicyQueryState buildQueryState(
    Policy policy,
    PolicyReExploreMode mode,
    PolicyFilterUiState filter, {
    PolicyFeedType feedType = PolicyFeedType.all,
  }) {
    final tags = mode == PolicyReExploreMode.similar ? _primaryTags(policy) : const <String>[];

    final query = PolicyQuery(
      feedType: feedType,
      filter: PolicyFilter(
        region: filter.region,
        province: filter.province,
        city: filter.city,
        district: filter.district,
        category: filter.category,
        isOnline: filter.showOnlyOnline ? true : null,
        institutionId: filter.institutionId,
        departmentId: filter.departmentId,
        tags: tags.isNotEmpty ? tags : filter.tags,
        status: filter.status,
      ),
      tags: tags.isNotEmpty ? tags : filter.tags,
      sort: _sortFor(mode, filter),
    ).normalize();

    return PolicyQueryState(
      query: query,
      hash: query.cacheScopeKey,
      summary: buildPolicyFilterSummary(filter),
      conditionSummary: buildPolicyFilterConditionSummary(filter),
    );
  }

  static PolicySortOption _sortFor(
    PolicyReExploreMode mode,
    PolicyFilterUiState filter,
  ) {
    switch (mode) {
      case PolicyReExploreMode.similar:
        return PolicySortOption.recommendation;
      case PolicyReExploreMode.institution:
      case PolicyReExploreMode.category:
        return filter.sort;
    }
  }

  static List<String> _primaryTags(Policy policy) {
    if (policy.tags.isNotEmpty) return policy.tags;
    if (policy.keywords.isNotEmpty) return policy.keywords;
    return const [];
  }
}
