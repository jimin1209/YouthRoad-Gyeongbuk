import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../filters/policy_filter_ui_state.dart';
import '../controllers/global_filter_controller.dart';
import 'explore_state.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_sort.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_status_filter.dart';
import '../reexplore/policy_reexplore.dart';
import '../../../../application/notifiers/region_notifier.dart';

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
    final hasRegionSelection = ref.read(regionProvider)?.isNotEmpty ?? false;
    ref.read(globalFilterControllerProvider).resetAll();
    state = state.copyWith(
      mode: hasRegionSelection ? ExploreSubMode.region : ExploreSubMode.all,
      keyword: '',
    );
  }

  void ensureRegionMode({required bool hasSelection}) {
    if (state.mode == ExploreSubMode.search && state.keyword.isNotEmpty) {
      return;
    }

    final nextMode = hasSelection ? ExploreSubMode.region : ExploreSubMode.all;
    if (state.mode != nextMode) {
      state = state.copyWith(mode: nextMode);
    }
  }

  void applyFromDetail({
    required PolicyFilterUiState filter,
    required PolicyReExploreMode mode,
  }) {
    final hasRegionSelection =
        (filter.city?.isNotEmpty ?? false) || (filter.district?.isNotEmpty ?? false);
    final nextMode = hasRegionSelection ? ExploreSubMode.region : ExploreSubMode.all;

    if (state.keyword.isNotEmpty) {
      _syncKeyword('');
    }
    state = state.copyWith(
      mode: nextMode,
      keyword: '',
    );
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
