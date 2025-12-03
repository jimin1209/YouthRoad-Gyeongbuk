import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_filter.dart';
import '../../domain/values/policy_query.dart';
import '../../domain/values/policy_region.dart';
import '../../domain/values/policy_sort.dart';
import '../filters/policy_filter_ui_state.dart';
import '../providers.dart';
import '../behavior/policy_behavior_tracker.dart';

class PolicyQueryOrchestrator {
  PolicyQueryOrchestrator(this.ref);

  final Ref ref;

  PolicyFilterUiState get _ui => ref.read(policyFilterUiStateProvider);
  UserProfile get _profile => ref.read(userProfileProvider);
  PolicyBehaviorState get _behavior =>
      ref.read(policyBehaviorTrackerProvider);

  List<String> get _favoriteIds => ref.read(favoriteIdsProvider).toList();

  List<String> get _compareIds => ref.read(compareRepositoryProvider).ids;

  PolicyQuery buildQuery(PolicyFeedType feedType) {
    switch (feedType) {
      case PolicyFeedType.recommend:
        return _buildRecommendQuery();
      case PolicyFeedType.all:
        return _buildAllQuery();
      case PolicyFeedType.region:
        return _buildRegionQuery();
      case PolicyFeedType.search:
        return _buildSearchQuery();
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
        isOngoing: _ui.showOnlyOngoing ? true : null,
        institutionId: _ui.institutionId,
        departmentId: _ui.departmentId,
        tags: baseTags,
      ),
      tags: combinedTags,
      sort: PolicySortOption.recommendation,
    );
  }

  PolicyQuery _buildAllQuery() {
    final filter = PolicyFilter(
      region: _ui.region,
      category: _ui.category,
      isOnline: _ui.showOnlyOnline ? true : null,
      isOngoing: _ui.showOnlyOngoing ? true : null,
      institutionId: _ui.institutionId,
      departmentId: _ui.departmentId,
      tags: _ui.tags,
    );

    return PolicyQuery(
      feedType: PolicyFeedType.all,
      keyword: _ui.keyword.isEmpty ? null : _ui.keyword,
      filter: filter,
      sort: _ui.sort,
    );
  }

  PolicyQuery _buildRegionQuery() {
    final region =
        _ui.region == PolicyRegion.all ? _profile.region : _ui.region;

    final filter = PolicyFilter(
      region: region,
      category: _ui.category,
      isOnline: _ui.showOnlyOnline ? true : null,
      isOngoing: _ui.showOnlyOngoing ? true : null,
      institutionId: _ui.institutionId,
      departmentId: _ui.departmentId,
    );

    return PolicyQuery(
      feedType: PolicyFeedType.region,
      filter: filter,
      sort: _ui.sort,
    );
  }

  PolicyQuery _buildSearchQuery() {
    final filter = PolicyFilter(
      region: _ui.region,
      category: _ui.category,
      isOnline: _ui.showOnlyOnline ? true : null,
      isOngoing: _ui.showOnlyOngoing ? true : null,
      institutionId: _ui.institutionId,
      departmentId: _ui.departmentId,
    );

    return PolicyQuery(
      feedType: PolicyFeedType.search,
      keyword: _ui.keyword.isEmpty ? null : _ui.keyword,
      filter: filter,
      tags: _ui.tags,
      sort: _ui.sort,
    );
  }

  PolicyQuery _buildFavoriteQuery() {
    return PolicyQuery(
      feedType: PolicyFeedType.favorite,
      filter: const PolicyFilter(),
      tags: _favoriteIds,
      sort: _ui.sort,
    );
  }

  PolicyQuery _buildCompareQuery() {
    return PolicyQuery(
      feedType: PolicyFeedType.compare,
      filter: const PolicyFilter(),
      tags: _compareIds,
      sort: _ui.sort,
    );
  }
}
