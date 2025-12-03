import '../values/policy_category.dart';
import '../values/policy_region.dart';

class UserProfile {
  final PolicyRegion region;
  final int? age;
  final List<PolicyCategory> preferredCategories;
  final List<String> recommendTags;

  const UserProfile({
    required this.region,
    this.age,
    this.preferredCategories = const [],
    this.recommendTags = const [],
  });

  UserProfile copyWith({
    PolicyRegion? region,
    int? age,
    List<PolicyCategory>? preferredCategories,
    List<String>? recommendTags,
  }) {
    return UserProfile(
      region: region ?? this.region,
      age: age ?? this.age,
      preferredCategories: preferredCategories ?? this.preferredCategories,
      recommendTags: recommendTags ?? this.recommendTags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'region': region.name,
      'age': age,
      'preferredCategories': preferredCategories.map((e) => e.name).toList(),
      'recommendTags': recommendTags,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final categories = (json['preferredCategories'] as List<dynamic>? ?? [])
        .whereType<String>()
        .map(PolicyCategory.values.byName)
        .toList();

    return UserProfile(
      region: PolicyRegion.values.byName(json['region'] as String),
      age: json['age'] as int?,
      preferredCategories: categories,
      recommendTags:
          (json['recommendTags'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}
