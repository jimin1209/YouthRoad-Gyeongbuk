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

  PolicyFilter normalize() {
    return PolicyFilter(
      region: region,
      category: category,
      isOnline: isOnline,
      isOngoing: isOngoing,
      isOffline: isOffline,
      age: age != null && age! > 0 ? age : null,
      tags: _normalizeTags(tags),
      institutionId: _normalizeId(institutionId),
      departmentId: _normalizeId(departmentId),
    );
  }

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

  static List<String> _normalizeTags(List<String> values) {
    final normalized = <String>[];
    for (final raw in values) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;
      if (!normalized.contains(trimmed)) {
        normalized.add(trimmed);
      }
    }
    return normalized;
  }

  static String? _normalizeId(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return trimmed;
  }
}
