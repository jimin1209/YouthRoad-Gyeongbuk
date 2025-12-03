import 'policy_category.dart';
import 'policy_region.dart';

class PolicyFilter {
  final PolicyRegion region;
  final PolicyCategory? category;
  final bool? isOnline;
  final bool? isOngoing;
  final bool? isOffline;
  final int? age;
  final List<String> tags;
  final String? institutionId;
  final String? departmentId;

  const PolicyFilter({
    this.region = PolicyRegion.all,
    this.category,
    this.isOnline,
    this.isOngoing,
    this.isOffline,
    this.age,
    this.tags = const [],
    this.institutionId,
    this.departmentId,
  });

  PolicyFilter copyWith({
    PolicyRegion? region,
    PolicyCategory? category,
    bool? isOnline,
    bool? isOngoing,
    bool? isOffline,
    int? age,
    List<String>? tags,
    String? institutionId,
    String? departmentId,
  }) {
    return PolicyFilter(
      region: region ?? this.region,
      category: category ?? this.category,
      isOnline: isOnline ?? this.isOnline,
      isOngoing: isOngoing ?? this.isOngoing,
      isOffline: isOffline ?? this.isOffline,
      age: age ?? this.age,
      tags: tags ?? this.tags,
      institutionId: institutionId ?? this.institutionId,
      departmentId: departmentId ?? this.departmentId,
    );
  }
}
