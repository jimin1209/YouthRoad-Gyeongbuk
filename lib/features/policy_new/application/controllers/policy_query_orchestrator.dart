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
import '../../../../application/notifiers/region_notifier.dart';

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
      case PolicyFeedType.bookmarked:
        return _buildBookmarkedQuery();
      case PolicyFeedType.compare:
        return _buildCompareQuery();
    }
  }

  PolicyQuery _buildRecommendQuery() {
    final manualTags = List<String>.unmodifiable(_ui.tags);
    final regionForRecommend = _ui.regionForApi;

    return PolicyQuery(
      feedType: PolicyFeedType.recommend,
      filter: _buildFilterFromUi(
        region: regionForRecommend,
        tags: manualTags,
        age: _profile.age,
        status: PolicyStatusFilter.inProgressOnly,
      ),
      tags: manualTags,
      sort: PolicySortOption.recommendation,
    ).normalize();
  }

  PolicyQuery _buildAllQuery(String keyword) {
    final filter = _buildFilterFromUi();

    return PolicyQuery(
      feedType: PolicyFeedType.all,
      keyword: keyword.isEmpty ? null : keyword,
      filter: filter,
      sort: _ui.sort,
    ).normalize();
  }

  PolicyQuery _buildRegionQuery() {
    final region = _ui.region == PolicyRegion.all ? _profile.region : _ui.region;
    final regionNotifier = ref.read(regionProvider.notifier);
    final hasCitySelection =
        regionNotifier.selectedCity != null || regionNotifier.selectedDistrict != null;
    final filter = _buildFilterFromUi(region: region);

    // region 피드가 시/군 선택이 없는 상태에서도 빈 결과만 내려오는 것을 막기 위해
    // 실제 쿼리는 기본(all) 스코프로 전송하되, 필터에는 지역 정보를 유지한다.
    final queryFeedType = hasCitySelection ? PolicyFeedType.region : PolicyFeedType.all;

    return PolicyQuery(
      feedType: queryFeedType,
      filter: filter,
      sort: _ui.sort,
    ).normalize();
  }

  PolicyQuery _buildSearchQuery(String keyword) {
    final filter = _buildFilterFromUi();

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

  PolicyQuery _buildBookmarkedQuery() {
    return PolicyQuery(
      feedType: PolicyFeedType.bookmarked,
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

  PolicyFilter _buildFilterFromUi({
    PolicyRegion? region,
    List<String>? tags,
    int? age,
    PolicyStatusFilter? status,
  }) {
    final resolvedRegion = region ?? _ui.region;
    final regionNotifier = ref.read(regionProvider.notifier);

    final resolvedProvince = resolvedRegion == PolicyRegion.gyeongbuk
        ? regionNotifier.selectedProvince
        : _provinceName(resolvedRegion, fallback: _ui.province);
    final resolvedCity =
        resolvedRegion == PolicyRegion.gyeongbuk ? regionNotifier.selectedCity : null;
    final resolvedDistrict = resolvedRegion == PolicyRegion.gyeongbuk
        ? regionNotifier.selectedDistrict
        : null;

    return PolicyFilter(
      region: resolvedRegion,
      province: resolvedProvince,
      city: resolvedCity,
      district: resolvedDistrict,
      category: _ui.category,
      isOnline: _ui.showOnlyOnline ? true : null,
      institutionId: _ui.institutionId,
      departmentId: _ui.departmentId,
      tags: tags ?? _ui.tags,
      status: status ?? _ui.status,
      age: age,
    );
  }

  String _provinceName(PolicyRegion region, {required String fallback}) {
    switch (region) {
      case PolicyRegion.all:
        return '전국';
      case PolicyRegion.seoul:
        return '서울';
      case PolicyRegion.busan:
        return '부산';
      case PolicyRegion.daegu:
        return '대구';
      case PolicyRegion.incheon:
        return '인천';
      case PolicyRegion.gwangju:
        return '광주';
      case PolicyRegion.daejeon:
        return '대전';
      case PolicyRegion.ulsan:
        return '울산';
      case PolicyRegion.gyeongbuk:
        return fallback.isEmpty ? '경상북도' : fallback;
    }
  }
}
