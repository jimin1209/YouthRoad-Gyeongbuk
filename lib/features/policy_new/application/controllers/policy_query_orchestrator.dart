import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_filter.dart';
import '../../domain/values/policy_query.dart';
import '../../domain/values/policy_region.dart';
import '../../domain/values/policy_sort.dart';
import '../../domain/values/policy_status_filter.dart';
import '../filters/policy_filter_ui_state.dart';
import '../providers.dart';
import '../behavior/policy_behavior_tracker.dart';
import '../../domain/recommendation/user_profile.dart';

class PolicyQueryOrchestrator {
  PolicyQueryOrchestrator(this.ref);

  final Ref ref;

  PolicyFilterUiState get _ui => ref.read(globalFilterProvider);
  UserProfile get _profile => ref.read(userProfileProvider);
  PolicyBehaviorState get _behavior =>
      ref.read(policyBehaviorTrackerProvider);

  List<String> get _favoriteIds => ref.read(favoriteIdsProvider).toList();

  List<String> get _compareIds => ref.read(compareRepositoryProvider).ids;

  PolicyQuery buildQuery(
    PolicyFeedType feedType, {
    String keyword = '',
  }) {
    switch (feedType) {
      case PolicyFeedType.recommend:
        return _buildRecommendQuery();
      case PolicyFeedType.all:
        return _buildAllQuery(keyword);
      case PolicyFeedType.region:
        return _buildRegionQuery();
      case PolicyFeedType.search:
        return _buildSearchQuery(keyword);
      case PolicyFeedType.favorite:
        return _buildFavoriteQuery();
      case PolicyFeedType.compare:
        return _buildCompareQuery();
    }
  }

  PolicyQuery _buildRecommendQuery() {
    final baseTags = _ui.tags.isNotEmpty ? _ui.tags : _profile.recommendTags;
    final behaviorTags = _behavior.topTags();

    final combinedTags = <String>[];
    void addAll(List<String> source) {
      for (final tag in source) {
        if (!combinedTags.contains(tag)) {
          combinedTags.add(tag);
        }
      }
    }

    addAll(baseTags);
    addAll(behaviorTags);

    return PolicyQuery(
      feedType: PolicyFeedType.recommend,
      filter: PolicyFilter(
        region: _ui.region == PolicyRegion.all ? _profile.region : _ui.region,
        category: _ui.category,
        age: _profile.age,
        isOnline: _ui.showOnlyOnline ? true : null,
        institutionId: _ui.institutionId,
        departmentId: _ui.departmentId,
        tags: baseTags,
        status: _ui.status,
      ),
      tags: combinedTags,
      sort: PolicySortOption.recommendation,
    ).normalize();
  }

  PolicyQuery _buildAllQuery(String keyword) {
    final filter = PolicyFilter(
      region: _ui.region,
      province: _ui.province,
      city: _ui.city,
      district: _ui.district,
      category: _ui.category,
      isOnline: _ui.showOnlyOnline ? true : null,
      institutionId: _ui.institutionId,
      departmentId: _ui.departmentId,
      tags: _ui.tags,
      status: _ui.status,
    );

    return PolicyQuery(
      feedType: PolicyFeedType.all,
      keyword: keyword.isEmpty ? null : keyword,
      filter: filter,
      sort: _ui.sort,
    ).normalize();
  }

  PolicyQuery _buildRegionQuery() {
    final region =
        _ui.region == PolicyRegion.all ? _profile.region : _ui.region;

    final filter = PolicyFilter(
      region: region,
      province: _ui.province,
      city: _ui.city,
      district: _ui.district,
      category: _ui.category,
      isOnline: _ui.showOnlyOnline ? true : null,
      institutionId: _ui.institutionId,
      departmentId: _ui.departmentId,
      status: _ui.status,
    );

    return PolicyQuery(
      feedType: PolicyFeedType.region,
      filter: filter,
      sort: _ui.sort,
    ).normalize();
  }

  PolicyQuery _buildSearchQuery(String keyword) {
    final filter = PolicyFilter(
      region: _ui.region,
      province: _ui.province,
      city: _ui.city,
      district: _ui.district,
      category: _ui.category,
      isOnline: _ui.showOnlyOnline ? true : null,
      institutionId: _ui.institutionId,
      departmentId: _ui.departmentId,
      status: _ui.status,
    );

    return PolicyQuery(
      feedType: PolicyFeedType.search,
      keyword: keyword.isEmpty ? null : keyword,
      filter: filter,
      tags: _ui.tags,
      sort: _ui.sort,
    ).normalize();
  }

  PolicyQuery _buildFavoriteQuery() {
    return PolicyQuery(
      feedType: PolicyFeedType.favorite,
      filter: const PolicyFilter(),
      tags: _favoriteIds,
      sort: _ui.sort,
    ).normalize(clearRecommendKeyword: false);
  }

  PolicyQuery _buildCompareQuery() {
    return PolicyQuery(
      feedType: PolicyFeedType.compare,
      filter: const PolicyFilter(),
      tags: _compareIds,
      sort: _ui.sort,
    ).normalize(clearRecommendKeyword: false);
  }
}
