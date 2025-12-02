class PolicyRecommendationScore {
  final String policyId;
  final double score;
  final List<String> matchedTags;

  const PolicyRecommendationScore({
    required this.policyId,
    required this.score,
    required this.matchedTags,
  });
}
