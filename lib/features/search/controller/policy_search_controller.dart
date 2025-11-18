import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../policy/data/policy_repository.dart';
import '../../policy/data/models/policy.dart';
import '../../policy/controller/policy_list_controller.dart';
import '../../policy/controller/policy_engagement_controller.dart';
import '../../bookmark/controller/bookmark_controller.dart';
import '../../policy/controller/policy_metadata_providers.dart';
import '../../../providers/global_providers.dart';
import '../../policy/data/models/category.dart';

class PolicySearchParams {
  final String? query;
  final String? region;
  final List<String> categories;
  final String? status;

  const PolicySearchParams({
    this.query,
    this.region,
    this.categories = const [],
    this.status,
  });
}

final policySearchControllerProvider =
    AutoDisposeAsyncNotifierProvider<PolicySearchController, List<Policy>>(
        PolicySearchController.new);

class PolicySearchController extends AutoDisposeAsyncNotifier<List<Policy>> {
  late final PolicyRepository _repository;
  PolicySearchParams _params = const PolicySearchParams();

  void setParams(PolicySearchParams params) {
    _params = params;
    ref.invalidateSelf();
  }

  @override
  Future<List<Policy>> build() async {
    _repository = ref.watch(policyRepositoryProvider);
    final globalFilter = ref.watch(policyFilterProvider);
    final engagement = ref.watch(policyEngagementControllerProvider);
    final bookmarked = ref.watch(bookmarkControllerProvider);
    final categoriesMeta = await ref.watch(categoryListProvider.future);
    final region = _params.region ?? globalFilter.region;
    final tagMatches = _extractTags(_params.query, categoriesMeta);
    final categories = _resolveCategories(globalFilter.categories, tagMatches);
    final overrides =
        _params.categories.isNotEmpty ? _params.categories : categories.toList();
    final effectiveCategories = overrides.toSet()..addAll(tagMatches);
    final status = _params.status ?? globalFilter.status;

    final results = await _repository.getPolicies(
      region: region,
      categories: effectiveCategories.isEmpty ? null : effectiveCategories.toList(),
      status: (status == null || status.isEmpty) ? null : status,
    );
    final filtered = _applyTextQuery(results, _params.query, tagMatches);
    final engagementState = engagement.maybeWhen(
      data: (value) => value,
      orElse: () => const PolicyEngagementState(),
    );
    final bookmarkedIds = bookmarked.maybeWhen(
      data: (entries) => entries.map((entry) => entry.policy.id).toSet(),
      orElse: () => <String>{},
    );
    final interestSeed = effectiveCategories.isNotEmpty
        ? effectiveCategories.toList()
        : globalFilter.categories;
    return _sortByRecommendation(
      filtered,
      interestSeed,
      region,
      engagementState,
      bookmarkedIds,
    );
  }

  List<Policy> _applyTextQuery(
    List<Policy> policies,
    String? query,
    List<String> tagMatches,
  ) {
    if (query == null || query.trim().isEmpty) {
      return policies;
    }
    final cleanedKeywords = _normalizeQuery(query)
        .split(RegExp(r'\s+'))
        .where((keyword) => keyword.isNotEmpty && !keyword.startsWith('#'))
        .map((keyword) => keyword.toLowerCase())
        .toList();
    return policies.where((policy) {
      final textBank =
          '${policy.title} ${policy.summary} ${policy.description}'.toLowerCase();
      final matchesKeyword = cleanedKeywords.isEmpty
          ? true
          : cleanedKeywords.any((keyword) => textBank.contains(keyword));
      final matchesTags = tagMatches.isEmpty
          ? true
          : tagMatches.every((tag) => policy.categories.contains(tag));
      return matchesKeyword && matchesTags;
    }).toList();
  }

  List<Policy> _sortByRecommendation(
    List<Policy> policies,
    List<String> interests,
    String? region,
    PolicyEngagementState engagementState,
    Set<String> bookmarkedIds,
  ) {
    final scored = policies
        .map(
          (policy) => MapEntry(
            policy,
            computePolicyScore(
              policy,
              interests,
              preferredRegion: region,
              recentPolicyIds: engagementState.recentPolicyIds,
              bookmarkedIds: bookmarkedIds,
              clickCounts: engagementState.clickCounts,
            ),
          ),
        )
        .toList();
    scored.sort((a, b) => b.value.compareTo(a.value));
    return scored.map((entry) => entry.key).toList();
  }

  List<String> _extractTags(String? query, List<Category> categories) {
    if (query == null) {
      return const [];
    }
    final normalized = _normalizeQuery(query);
    final tagCandidates =
        RegExp(r'#([가-힣a-zA-Z0-9_-]+)').allMatches(normalized).map((match) => match.group(1)!).toList();
    if (tagCandidates.isEmpty) {
      return const [];
    }
    final resolved = <String>[];
    for (final candidate in tagCandidates) {
      final lower = candidate.toLowerCase();
      final match = categories.firstWhere(
        (category) =>
            category.code.toLowerCase() == lower ||
            category.name.toLowerCase() == lower,
        orElse: () => Category(code: '', name: ''),
      );
      if (match.code.isNotEmpty) {
        resolved.add(match.code);
      }
    }
    return resolved;
  }

  Set<String> _resolveCategories(List<String> base, List<String> tagMatches) {
    final resolved = base.toSet();
    resolved.addAll(tagMatches);
    return resolved;
  }

  String _normalizeQuery(String query) {
    return query.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
