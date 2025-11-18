import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/policy_repository.dart';
import '../data/models/policy.dart';
import '../../../providers/global_providers.dart';
import '../../profile/providers/user_preferences_provider.dart';
import '../../bookmark/controller/bookmark_controller.dart';
import 'policy_engagement_controller.dart';

class PolicyFilter {
  final String? region;
  final int? age;
  final List<String> categories;
  final String? status;

  const PolicyFilter({
    this.region,
    this.age,
    List<String> categories = const [],
    this.status,
  }) : categories = List.unmodifiable(categories);

  PolicyFilter copyWith({
    String? region,
    int? age,
    List<String>? categories,
    String? status,
  }) {
    return PolicyFilter(
      region: region ?? this.region,
      age: age ?? this.age,
      categories: categories ?? this.categories,
      status: status ?? this.status,
    );
  }

  factory PolicyFilter.initial() => const PolicyFilter();
}

final policyFilterStateProvider = StateProvider<PolicyFilter>((ref) {
  return PolicyFilter.initial();
});

/// Indicates whether global filters should fall back to the user's profile.
final policyFilterUseProfileProvider = StateProvider<bool>((ref) => true);

/// Combines explicit filter overrides with the user's onboarding profile.
final policyFilterProvider = Provider<PolicyFilter>((ref) {
  final overrides = ref.watch(policyFilterStateProvider);
  final useProfile = ref.watch(policyFilterUseProfileProvider);
  final userRegion = ref.watch(userRegionProvider);
  final userAge = ref.watch(userAgeProvider);
  final userInterests = ref.watch(userInterestsProvider);

  if (!useProfile) {
    return overrides;
  }

  final resolvedCategories = overrides.categories.isNotEmpty
      ? overrides.categories
      : userInterests;

  return overrides.copyWith(
    region: overrides.region ?? userRegion,
    age: overrides.age ?? userAge,
    categories: resolvedCategories,
  );
});

final policyListControllerProvider =
    AutoDisposeAsyncNotifierProvider<PolicyListController, List<Policy>>(
        PolicyListController.new);

class PolicyListController extends AutoDisposeAsyncNotifier<List<Policy>> {
  late final PolicyRepository _repository;

  @override
  Future<List<Policy>> build() async {
    _repository = ref.watch(policyRepositoryProvider);
    final filter = ref.watch(policyFilterProvider);
    final engagement = ref.watch(policyEngagementControllerProvider);
    final bookmarked = ref.watch(bookmarkControllerProvider);
    final categories = filter.categories.isEmpty ? null : filter.categories;
    final status = (filter.status == null || filter.status!.isEmpty)
        ? null
        : filter.status;
    final policies = await _repository.getPolicies(
      region: filter.region,
      age: filter.age,
      categories: categories,
      status: status,
    );
    final engagementState = engagement.maybeWhen(
      data: (value) => value,
      orElse: () => const PolicyEngagementState(),
    );
    final bookmarkedIds = bookmarked.maybeWhen(
      data: (entries) => entries.map((entry) => entry.policy.id).toSet(),
      orElse: () => <String>{},
    );
    return _sortedByScore(
      policies,
      filter,
      engagementState,
      bookmarkedIds,
    );
  }

  List<Policy> _sortedByScore(
    List<Policy> policies,
    PolicyFilter filter,
    PolicyEngagementState engagementState,
    Set<String> bookmarkedIds,
  ) {
    final interests = filter.categories;
    final scored = policies
        .map(
          (p) => MapEntry(
            p,
            computePolicyScore(
              p,
              interests,
              preferredRegion: filter.region,
              recentPolicyIds: engagementState.recentPolicyIds,
              bookmarkedIds: bookmarkedIds,
              clickCounts: engagementState.clickCounts,
            ),
          ),
        )
        .toList();
    scored.sort((a, b) => b.value.compareTo(a.value));
    return scored.map((e) => e.key).toList();
  }
}
