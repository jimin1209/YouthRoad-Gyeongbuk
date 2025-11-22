import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/result.dart';
import '../../data/model/policy_models.dart';
import '../../data/repository/youth_policy_repository.dart';
import '../region/region_model.dart';
import '../region/region_provider.dart';
import 'policy_filter.dart';
import 'policy_list_state.dart';

class PolicyListNotifier extends StateNotifier<PolicyListState> {
  PolicyListNotifier(this._ref)
      : super(
          PolicyListState.initial(
            PolicyFilter(
              regionCodes: _regionCodes(_ref.read(selectedRegionProvider)),
            ),
          ),
        ) {
    _ref.listen<Region?>(selectedRegionProvider, (previous, next) {
      final List<String> codes = _regionCodes(next);
      state = state.copyWith(
        filter: state.filter.copyWith(regionCodes: codes, pageIndex: 1),
      );
      fetchPolicies(refresh: true);
    });
  }

  final Ref _ref;

  static List<String> _regionCodes(Region? region) {
    if (region == null || region.code.isEmpty) return <String>[];
    return <String>[region.code];
  }

  Future<void> fetchPolicies({bool refresh = false}) async {
    final YouthPolicyRepository repo = _ref.read(youthPolicyRepositoryProvider);
    final PolicyFilter workingFilter = refresh ? state.filter.copyWith(pageIndex: 1) : state.filter;

    state = state.copyWith(
      isLoading: refresh ? true : state.isLoading,
      isLoadingMore: refresh ? false : true,
      error: null,
      filter: workingFilter,
    );

    final Result<PolicyListResponse> result = await repo.fetchPolicies(
      searchYear: workingFilter.searchYear,
      searchPolicyNm: workingFilter.searchPolicyNm,
      searchPolicyType: workingFilter.policyTypes,
      searchRgnSe: workingFilter.regionCodes,
      instNo: workingFilter.instNo,
      deptNo: workingFilter.deptNo,
      pageIndex: workingFilter.pageIndex,
      recordCount: workingFilter.recordCount,
      pageSize: workingFilter.pageSize,
      pagingYn: workingFilter.pagingYn,
      searchDsplyYn: workingFilter.searchDsplyYn,
      aplyPsbltyYn: workingFilter.onlyAvailable ? 'Y' : null,
    );

    result.when(
      success: (response) {
        final pagination = response.paginationInfo;
        final bool hasNext = (pagination?.currentPageNo ?? 1) < (pagination?.totalPageCount ?? 1);
        final List<PolicyItem> newItems = refresh
            ? response.resultList
            : <PolicyItem>[...state.items, ...response.resultList];
        final int nextPage = workingFilter.pageIndex + 1;
        state = state.copyWith(
          items: newItems,
          isLoading: false,
          isLoadingMore: false,
          error: null,
          filter: state.filter.copyWith(pageIndex: nextPage),
          hasNext: hasNext,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: error,
        );
      },
    );
  }

  Future<void> fetchMore() async {
    if (state.isLoadingMore || !state.hasNext) return;
    await fetchPolicies(refresh: false);
  }

  void updateFilter(PolicyFilter filter, {bool refresh = true}) {
    state = state.copyWith(filter: filter.copyWith(pageIndex: 1));
    if (refresh) {
      fetchPolicies(refresh: true);
    }
  }

  void setSearchKeyword(String value) {
    updateFilter(state.filter.copyWith(searchPolicyNm: value, pageIndex: 1));
  }

  void setSearchYear(String? year) {
    updateFilter(state.filter.copyWith(searchYear: year, pageIndex: 1));
  }

  void togglePolicyType(String type) {
    final List<String> nextTypes = List<String>.from(state.filter.policyTypes);
    if (nextTypes.contains(type)) {
      nextTypes.remove(type);
    } else {
      nextTypes.add(type);
    }
    updateFilter(state.filter.copyWith(policyTypes: nextTypes, pageIndex: 1));
  }

  void setOnlyAvailable(bool value) {
    updateFilter(state.filter.copyWith(onlyAvailable: value, pageIndex: 1));
  }

  void setInstitutionFilter({String? instNo, String? deptNo}) {
    updateFilter(
      state.filter.copyWith(instNo: instNo, deptNo: deptNo, pageIndex: 1),
    );
  }
}

final policyListNotifierProvider =
    StateNotifierProvider<PolicyListNotifier, PolicyListState>(
  (ref) => PolicyListNotifier(ref),
);
