import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/notifiers/region_notifier.dart';
import '../filters/policy_filter_ui_state.dart';
import 'explore_state.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_sort.dart';

final exploreStateProvider =
    StateNotifierProvider<ExploreController, ExploreState>(
  (ref) => ExploreController(ref),
);

class ExploreController extends StateNotifier<ExploreState> {
  ExploreController(this.ref) : super(const ExploreState());

  final Ref ref;

  void setMode(ExploreSubMode mode) {
    debugPrint('[Explore] setMode: $mode');
    if (mode != ExploreSubMode.search && state.keyword.isNotEmpty) {
      _syncKeyword('');
      state = state.copyWith(keyword: '');
    }
    if (mode == ExploreSubMode.region && state.selectedRegionCode == null) {
      setMyRegion();
    }
    state = state.copyWith(mode: mode);
  }

  void setKeyword(String value) {
    final trimmed = value.trim();
    debugPrint('[Explore] setKeyword: "$trimmed"');
    if (trimmed.isEmpty) {
      _syncKeyword('');
      state = state.copyWith(
        keyword: '',
        mode: state.mode == ExploreSubMode.search
            ? ExploreSubMode.all
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

  Future<void> setMyRegion() async {
    debugPrint('[Explore] setMyRegion');
    final notifier = ref.read(regionProvider.notifier);
    final city = notifier.selectedCity;
    final summary = notifier.summary;
    if (city != null && city.isNotEmpty) {
      state = state.copyWith(
        selectedRegionName: summary,
        selectedRegionCode: city,
        useMyRegionAsDefault: true,
        mode: ExploreSubMode.region,
      );
    } else {
      state = state.copyWith(
        selectedRegionName: '경북 전체',
        selectedRegionCode: null,
        useMyRegionAsDefault: true,
        mode: ExploreSubMode.region,
      );
    }
  }

  void setCustomRegion({required String name, required String code}) {
    debugPrint('[Explore] setCustomRegion: $name ($code)');
    state = state.copyWith(
      selectedRegionName: name,
      selectedRegionCode: code,
      useMyRegionAsDefault: false,
      mode: ExploreSubMode.region,
    );
  }

  void _syncKeyword(String keyword) {
    ref.read(policyFilterUiStateProvider.notifier).setKeyword(keyword);
  }

  void setStatusFilter(PolicyStatusFilter filter) {
    debugPrint('[Explore] setStatus: $filter');
    state = state.copyWith(statusFilter: filter);
    final filterNotifier = ref.read(policyFilterUiStateProvider.notifier);
    final current = ref.read(policyFilterUiStateProvider).showOnlyOngoing;
    final shouldBeOngoingOnly = filter == PolicyStatusFilter.inProgressOnly;
    if (shouldBeOngoingOnly != current) {
      filterNotifier.toggleOngoingOnly();
    }
  }

  void setSortKind(PolicySortKind sortKind) {
    debugPrint('[Explore] setSort: $sortKind');
    state = state.copyWith(sortKind: sortKind);
    final notifier = ref.read(policyFilterUiStateProvider.notifier);
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
    final current = [...state.selectedCategories];
    if (current.contains(categoryId)) {
      current.remove(categoryId);
    } else {
      current.add(categoryId);
    }
    state = state.copyWith(selectedCategories: current);

    final catEnum = _mapCategory(categoryId);
    ref.read(policyFilterUiStateProvider.notifier).setCategory(catEnum);
  }

  void clearFilters() {
    debugPrint('[Explore] clearFilters');
    state = state.copyWith(
      statusFilter: PolicyStatusFilter.inProgressOnly,
      sortKind: PolicySortKind.recommended,
      selectedCategories: const [],
      selectedSupportTypes: const [],
    );
    final notifier = ref.read(policyFilterUiStateProvider.notifier);
    notifier.resetAll();
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
