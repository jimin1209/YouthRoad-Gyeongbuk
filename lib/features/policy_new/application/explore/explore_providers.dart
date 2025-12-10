import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../filters/policy_filter_ui_state.dart';
import '../controllers/global_filter_controller.dart';
import 'explore_state.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_sort.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_status_filter.dart';
import '../../domain/values/policy_region.dart';
import '../reexplore/policy_reexplore.dart';
import '../../../../application/notifiers/region_notifier.dart';

final exploreStateProvider =
    StateNotifierProvider<ExploreController, ExploreState>(
  (ref) => ExploreController(ref),
);

class ExploreController extends StateNotifier<ExploreState> {
  ExploreController(this.ref) : super(_initialState(ref));

  final Ref ref;

  static ExploreState _initialState(Ref ref) {
    final initialRegion = ref.read(regionProvider);
    final hasSelection = initialRegion?.isNotEmpty ?? false;
    final filterRegion = ref.read(globalFilterProvider).region;
    final isRegional = hasSelection || filterRegion != PolicyRegion.all;
    return ExploreState(
      mode: isRegional ? ExploreSubMode.region : ExploreSubMode.all,
    );
  }

  void setMode(ExploreSubMode mode) {
    debugPrint('[Explore] setMode: $mode');
    if (mode != ExploreSubMode.search && state.keyword.isNotEmpty) {
      _syncKeyword('');
      state = state.copyWith(keyword: '');
    }
    state = state.copyWith(mode: mode);
  }

  void setKeyword(String value) {
    final trimmed = value.trim();
    debugPrint('[Explore] setKeyword: "$trimmed"');
    final hasRegionSelection = ref.read(regionProvider)?.isNotEmpty ?? false;
    if (trimmed.isEmpty) {
      _syncKeyword('');
      state = state.copyWith(
        keyword: '',
        mode: state.mode == ExploreSubMode.search
            ? (hasRegionSelection ? ExploreSubMode.region : ExploreSubMode.all)
            : state.mode,
      );
      return;
    }
    _syncKeyword(trimmed);
    state = state.copyWith(
      keyword: trimmed,
      mode: ExploreSubMode.search,
    );
  }

  void clearKeyword() => setKeyword('');

  void _syncKeyword(String keyword) {
    ref
        .read(globalFilterControllerProvider)
        .setKeyword(PolicyFeedType.search, keyword);
  }

  void setStatusFilter(PolicyStatusFilter filter) {
    debugPrint('[Explore] setStatus: $filter');
    final filterNotifier = ref.read(globalFilterProvider.notifier);
    filterNotifier.setStatus(filter);
  }

  void setSortKind(PolicySortKind sortKind) {
    debugPrint('[Explore] setSort: $sortKind');
    final notifier = ref.read(globalFilterProvider.notifier);
    PolicySortOption option;
    switch (sortKind) {
      case PolicySortKind.recommended:
        option = PolicySortOption.recommendation;
        break;
      case PolicySortKind.newest:
        option = PolicySortOption.latest;
        break;
      case PolicySortKind.deadline:
        option = PolicySortOption.deadline;
        break;
      case PolicySortKind.amount:
        option = PolicySortOption.popularity;
        break;
    }
    notifier.setSort(option);
  }

  void toggleCategory(String categoryId) {
    debugPrint('[Explore] toggleCategory: $categoryId');
    final catEnum = _mapCategory(categoryId);
    final current = ref.read(globalFilterProvider).category;
    ref
        .read(globalFilterProvider.notifier)
        .setCategory(current == catEnum ? null : catEnum);
  }

  void clearFilters() {
    debugPrint('[Explore] clearFilters');
    ref.read(globalFilterControllerProvider).resetAll();
    final hasRegionSelection = ref.read(regionProvider)?.isNotEmpty ?? false;
    state = state.copyWith(
      mode: hasRegionSelection ? ExploreSubMode.region : ExploreSubMode.all,
      keyword: '',
    );
  }

  void ensureRegionMode({required bool hasSelection}) {
    if (state.mode == ExploreSubMode.search && state.keyword.isNotEmpty) {
      return;
    }

    final filterRegion = ref.read(globalFilterProvider).region;
    final isRegional = hasSelection || filterRegion != PolicyRegion.all;
    final nextMode = isRegional ? ExploreSubMode.region : ExploreSubMode.all;
    if (state.mode != nextMode) {
      debugPrint(
        '[Policy][Explore] ensureRegionMode -> $nextMode '
        '(selection=$hasSelection, filterRegion=${filterRegion.name})',
      );
      state = state.copyWith(mode: nextMode);
    }
  }

  void applyFromDetail({
    required PolicyFilterUiState filter,
    required PolicyReExploreMode mode,
  }) {
    final regionNotifier = ref.read(regionProvider.notifier);
    final selectedProvince = regionNotifier.selectedProvince;
    final hasRegionSelection =
        filter.province.trim() == selectedProvince &&
            ((filter.city?.isNotEmpty ?? false) || (filter.district?.isNotEmpty ?? false));
    final nextMode = hasRegionSelection ? ExploreSubMode.region : ExploreSubMode.all;

    _syncRegionSelection(filter);

    if (state.keyword.isNotEmpty) {
      _syncKeyword('');
    }
    state = state.copyWith(
      mode: nextMode,
      keyword: '',
    );
  }

  void _syncRegionSelection(PolicyFilterUiState filter) {
    final regionNotifier = ref.read(regionProvider.notifier);
    final selectedProvince = regionNotifier.selectedProvince;
    final filterProvince = filter.province.trim();
    final filterRegion = filter.region;
    final filterNotifier = ref.read(globalFilterProvider.notifier);
    final city = filter.city?.trim();
    final district = filter.district?.trim();

    if (filterProvince != selectedProvince) {
      if (regionNotifier.selectedCity != null || regionNotifier.selectedDistrict != null) {
        regionNotifier.resetCity();
        filterNotifier.setRegion(filterRegion);
      }
      return;
    }

    if (city == null || city.isEmpty) {
      if (regionNotifier.selectedCity != null || regionNotifier.selectedDistrict != null) {
        regionNotifier.resetCity();
      }
      return;
    }

    if (!regionNotifier.availableCities.contains(city)) {
      regionNotifier.resetCity();
      return;
    }

    if (regionNotifier.selectedCity != city) {
      regionNotifier.selectCity(city);
    }

    final hasDistrict = district != null && district.isNotEmpty;
    if (hasDistrict) {
      if (regionNotifier.selectedDistrict != district) {
        regionNotifier.selectDistrict(district);
      }
    } else if (regionNotifier.selectedDistrict != null) {
      regionNotifier.selectDistrict(null);
    }
  }

  PolicyCategory? _mapCategory(String id) {
    switch (id) {
      case 'employment':
        return PolicyCategory.employment;
      case 'startup':
        return PolicyCategory.startup;
      case 'housing':
        return PolicyCategory.housing;
      case 'education':
        return PolicyCategory.education;
      case 'life':
        return PolicyCategory.life;
      default:
        return null;
    }
  }

}
