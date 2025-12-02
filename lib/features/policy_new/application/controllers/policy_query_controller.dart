import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_filter.dart';
import '../../domain/values/policy_query.dart';
import '../../domain/values/policy_region.dart';
import '../../domain/values/policy_sort.dart';

class PolicyQueryController extends StateNotifier<PolicyQuery> {
  PolicyQueryController({required PolicyQuery initialQuery})
      : super(initialQuery);

  void setKeyword(String keyword) {
    if (state.keyword == keyword) return;
    state = state.copyWith(keyword: keyword);
  }

  void setRegion(PolicyRegion region) {
    if (state.filter.region == region) return;
    state = state.copyWith(filter: state.filter.copyWith(region: region));
  }

  void setCategory(PolicyCategory? category) {
    if (state.filter.category == category) return;
    state = state.copyWith(filter: state.filter.copyWith(category: category));
  }

  void setTags(List<String> tags) {
    state = state.copyWith(
      tags: tags,
      filter: state.filter.copyWith(tags: tags),
    );
  }

  void setSort(PolicySortOption sort) {
    if (state.sort == sort) return;
    state = state.copyWith(sort: sort);
  }

  void setIsOnline(bool? isOnline) {
    if (state.filter.isOnline == isOnline) return;
    state = state.copyWith(filter: state.filter.copyWith(isOnline: isOnline));
  }

  void setIsOffline(bool? isOffline) {
    if (state.filter.isOffline == isOffline) return;
    state = state.copyWith(filter: state.filter.copyWith(isOffline: isOffline));
  }

  void setIsOngoing(bool? isOngoing) {
    if (state.filter.isOngoing == isOngoing) return;
    state = state.copyWith(filter: state.filter.copyWith(isOngoing: isOngoing));
  }

  void setAge(int? age) {
    if (state.filter.age == age) return;
    state = state.copyWith(filter: state.filter.copyWith(age: age));
  }
}
