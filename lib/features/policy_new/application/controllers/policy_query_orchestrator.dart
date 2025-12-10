import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_filter.dart';
import '../../domain/values/policy_query.dart';
import '../../domain/values/policy_region.dart';
import '../../domain/values/policy_sort.dart';
import '../../domain/values/policy_status_filter.dart';
import '../filters/policy_filter_ui_state.dart';
import '../providers.dart';
import '../../domain/recommendation/user_profile.dart';
import '../../../../application/notifiers/region_notifier.dart';

class PolicyQueryOrchestrator {
  PolicyQueryOrchestrator(this.ref);

  final Ref ref;

  PolicyFilterUiState get _ui => ref.read(globalFilterProvider);
  UserProfile get _profile => ref.read(userProfileProvider);

  List<String> get _favoriteIds => ref.read(favoriteIdsProvider).toList();

  List<String> get _compareIds => ref.read(compareRepositoryProvider).ids;

  PolicyQuery buildQuery(
    PolicyFeedType feedType, {
    String keyword = '',
  }) {
    switch (feedType) {
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

  PolicyQuery _buildAllQuery(String keyword) {
    final filter = _buildFilterFromUi(
      applyExploreSanitizer: true,
      searchRgnSe: _resolveExploreSearchRegion(_ui.region),
    );

    return PolicyQuery(
      feedType: PolicyFeedType.all,
      keyword: keyword.isEmpty ? null : keyword,
      filter: filter,
      sort: _ui.sort,
    ).normalize();
  }

  PolicyQuery _buildRegionQuery() {
    final region = _ui.region == PolicyRegion.all ? _profile.region : _ui.region;
    final filter = _buildFilterFromUi(
      region: region,
      applyExploreSanitizer: true,
      searchRgnSe: _resolveExploreSearchRegion(region),
    );

    return PolicyQuery(
      feedType: PolicyFeedType.region,
      filter: filter,
      sort: _ui.sort,
    ).normalize();
  }

  PolicyQuery _buildSearchQuery(String keyword) {
    final filter = _buildFilterFromUi(
      applyExploreSanitizer: true,
      searchRgnSe: _resolveExploreSearchRegion(_ui.region),
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
    ).normalize();
  }

  PolicyQuery _buildBookmarkedQuery() {
    return PolicyQuery(
      feedType: PolicyFeedType.bookmarked,
      filter: const PolicyFilter(),
      tags: _favoriteIds,
      sort: _ui.sort,
    ).normalize();
  }

  PolicyQuery _buildCompareQuery() {
    return PolicyQuery(
      feedType: PolicyFeedType.compare,
      filter: const PolicyFilter(),
      tags: _compareIds,
      sort: _ui.sort,
    ).normalize();
  }

  PolicyFilter _buildFilterFromUi({
    PolicyRegion? region,
    PolicyCategory? category,
    List<String>? tags,
    int? age,
    PolicyStatusFilter? status,
    String? searchRgnSe,
    bool applyExploreSanitizer = false,
  }) {
    final resolvedRegion = region ?? _ui.region;
    final regionNotifier = ref.read(regionProvider.notifier);

    final selectedStatus = status ?? _ui.status;
    final sanitizedStatus = applyExploreSanitizer
        ? (selectedStatus == PolicyStatusFilter.includeClosed
            ? PolicyStatusFilter.inProgressOnly
            : selectedStatus)
        : selectedStatus;

    final selectedCategory = category ?? _ui.category;
    final sanitizedCategory = applyExploreSanitizer
        ? _sanitizeCategoryForExplore(selectedCategory)
        : selectedCategory;

    final resolvedProvince = resolvedRegion == PolicyRegion.gyeongbuk
        ? regionNotifier.selectedProvince
        : _provinceName(resolvedRegion, fallback: _ui.province);
    final resolvedCity =
        resolvedRegion == PolicyRegion.gyeongbuk ? regionNotifier.selectedCity : null;
    final resolvedDistrict = resolvedRegion == PolicyRegion.gyeongbuk
        ? regionNotifier.selectedDistrict
        : null;

    return PolicyFilter(
      searchRgnSe: searchRgnSe,
      region: resolvedRegion,
      province: resolvedProvince,
      city: resolvedCity,
      district: resolvedDistrict,
      category: sanitizedCategory,
      isOnline: _ui.showOnlyOnline ? true : null,
      institutionId: _ui.institutionId,
      departmentId: _ui.departmentId,
      tags: tags ?? _ui.tags,
      status: sanitizedStatus,
      age: age,
    );
  }

  PolicyCategory? _sanitizeCategoryForExplore(PolicyCategory? category) {
    final categoryName = category?.name.toLowerCase();
    if (categoryName == 'all') return null;
    return category;
  }

  String? _resolveExploreSearchRegion(PolicyRegion region) {
    final notifier = ref.read(regionProvider.notifier);
    final city = _normalizeRegionSegment(notifier.selectedCity);
    final district = _normalizeRegionSegment(notifier.selectedDistrict);

    if (city != null && city.isNotEmpty) {
      if (district != null && district.isNotEmpty) {
        return '$city|$district';
      }
      return city;
    }

    if (region == PolicyRegion.all) return null;

    if (region == PolicyRegion.gyeongbuk) {
      final province = notifier.selectedProvince.trim();
      if (province.isNotEmpty) return province;
    }

    return _displayRegionName(region);
  }

  String? _normalizeRegionSegment(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed == '전체') return null;
    return trimmed;
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

  String _displayRegionName(PolicyRegion region) {
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
        return '경상북도';
    }
  }
}
