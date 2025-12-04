import '../../domain/entities/policy.dart';

class CompareState {
  final List<Policy> policies;
  final Map<String, bool> diffs;
  final CompareInsights insights;

  const CompareState({
    required this.policies,
    required this.diffs,
    required this.insights,
  });

  const CompareState.empty()
      : policies = const [],
        diffs = const {},
        insights = const CompareInsights();
}

class CompareInsights {
  final String? recommendedPolicyId;
  final String? recommendedTitle;
  final int recommendedScore;
  final String? nearestDeadlinePolicyId;
  final String? nearestDeadlineTitle;
  final int? nearestDeadlineDays;
  final String? broadEligibilityPolicyId;
  final String? broadEligibilityTitle;

  const CompareInsights({
    this.recommendedPolicyId,
    this.recommendedTitle,
    this.recommendedScore = 0,
    this.nearestDeadlinePolicyId,
    this.nearestDeadlineTitle,
    this.nearestDeadlineDays,
    this.broadEligibilityPolicyId,
    this.broadEligibilityTitle,
  });

  bool get hasRecommendation => recommendedPolicyId != null;
  bool get hasNearestDeadline => nearestDeadlinePolicyId != null;
  bool get hasEligibilityHighlight => broadEligibilityPolicyId != null;
}
