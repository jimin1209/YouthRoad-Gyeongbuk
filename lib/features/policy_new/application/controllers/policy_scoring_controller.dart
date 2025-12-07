import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/policy_query.dart';
import '../../domain/values/policy_region.dart';
import '../providers.dart';
import 'policy_behavior_controller.dart';

class PolicyScoreController extends StateNotifier<Map<String, double>> {
  PolicyScoreController(this.ref) : super(const {});

  final Ref ref;

  void reset() {
    state = const {};
  }

  List<Policy> applyScore(
    List<Policy> policies, {
    required PolicyQuery query,
  }) {
    if (policies.isEmpty) {
      reset();
      return policies;
    }

    final behaviorNotifier = ref.read(policyBehaviorProvider.notifier);
    final favoriteIds = ref.read(favoriteRepositoryProvider).allIds;
    behaviorNotifier.syncFavorites(policies, favoriteIds);
    final behavior = ref.read(policyBehaviorProvider);

    final viewedTags = behavior.recentViewedPolicies
        .expand((record) => record.tags)
        .toSet();
    final favoriteTags = behavior.recentFavorites
        .expand((record) => record.tags)
        .toSet();
    final latestViewed = behavior.recentViewedPolicies.isNotEmpty
        ? behavior.recentViewedPolicies.first
        : null;

    final preferredRegion = _preferredRegion(query);

    final rawScores = <String, double>{};
    for (final policy in policies) {
      double score = 0;

      final viewedIntersection =
          policy.tags.where((tag) => viewedTags.contains(tag)).length;
      final favoriteIntersection =
          policy.tags.where((tag) => favoriteTags.contains(tag)).length;

      score += viewedIntersection * 6;
      score += favoriteIntersection * 10;

      if (preferredRegion != null && policy.region == preferredRegion) {
        score += 12;
      }

      if (latestViewed != null) {
        if (policy.id == latestViewed.policyId) {
          score += 18;
        } else {
          final matchesCategory = policy.category == latestViewed.category;
          final matchesRegion = policy.region == latestViewed.region;
          if (matchesCategory) score += 8;
          if (matchesRegion) score += 6;
        }
      }

      rawScores[policy.id] = score;
    }

    final normalized = _normalize(rawScores);
    state = normalized;

    final sorted = List<Policy>.from(policies);
    sorted.sort((a, b) {
      final scoreA = normalized[a.id] ?? 0;
      final scoreB = normalized[b.id] ?? 0;
      if (scoreA != scoreB) return scoreB.compareTo(scoreA);
      return b.createdAt.compareTo(a.createdAt);
    });

    return sorted;
  }

  PolicyRegion? _preferredRegion(PolicyQuery query) {
    if (query.filter.region != PolicyRegion.all) {
      return query.filter.region;
    }
    return ref.read(userProfileProvider).region;
  }

  Map<String, double> _normalize(Map<String, double> rawScores) {
    if (rawScores.isEmpty) return const {};
    final maxScore = rawScores.values.fold<double>(0, (prev, element) {
      return element > prev ? element : prev;
    });

    if (maxScore == 0) {
      return rawScores.map((key, value) => MapEntry(key, 0));
    }

    return rawScores.map(
      (key, value) => MapEntry(
        key,
        (value / maxScore) * 100,
      ),
    );
  }
}
