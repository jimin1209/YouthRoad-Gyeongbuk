class Policy {
  const Policy({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.tags,
    this.policyUrl,
    this.agency,
    this.department,
    this.eligibilityAge,
    this.eligibilityRegion,
    this.applicationMethod,
    this.requiredDocuments,
    this.contact,
    this.periodStart,
    this.periodEnd,
    this.dday,
    this.isOngoing,
  });

  final String id;
  final String title;
  final String category;
  final String summary;
  final List<String> tags;
  final String? policyUrl;
  final String? agency;
  final String? department;
  final int? eligibilityAge;
  final String? eligibilityRegion;
  final String? applicationMethod;
  final String? requiredDocuments;
  final String? contact;
  final String? periodStart;
  final String? periodEnd;
  final int? dday;
  final bool? isOngoing;
}
