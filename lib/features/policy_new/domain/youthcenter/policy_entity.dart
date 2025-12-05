class PolicyEntity {
  const PolicyEntity({
    required this.title,
    required this.period,
    required this.organization,
    required this.region,
    this.ageCondition,
    this.jobCondition,
    this.educationCondition,
    this.benefit,
    this.applyMethod,
    this.detailsUrl,
  });

  final String title;
  final String period;
  final String organization;
  final String region;
  final String? ageCondition;
  final String? jobCondition;
  final String? educationCondition;
  final String? benefit;
  final String? applyMethod;
  final String? detailsUrl;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'period': period,
      'organization': organization,
      'region': region,
      'ageCondition': ageCondition,
      'jobCondition': jobCondition,
      'educationCondition': educationCondition,
      'benefit': benefit,
      'applyMethod': applyMethod,
      'detailsUrl': detailsUrl,
    };
  }

  factory PolicyEntity.fromJson(Map<String, dynamic> json) {
    return PolicyEntity(
      title: json['title'] as String? ?? '',
      period: json['period'] as String? ?? '',
      organization: json['organization'] as String? ?? '',
      region: json['region'] as String? ?? '',
      ageCondition: json['ageCondition'] as String?,
      jobCondition: json['jobCondition'] as String?,
      educationCondition: json['educationCondition'] as String?,
      benefit: json['benefit'] as String?,
      applyMethod: json['applyMethod'] as String?,
      detailsUrl: json['detailsUrl'] as String?,
    );
  }
}
