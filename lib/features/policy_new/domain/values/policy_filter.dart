import 'policy_status_filter.dart';
import 'policy_category.dart';
import 'policy_region.dart';

class PolicyFilter {
  final PolicyRegion region;
  final String province;
  final String? city;
  final String? district;
  final PolicyCategory? category;
  final bool? isOnline;
  final bool? isOffline;
  final int? age;
  final List<String> tags;
  final String? institutionId;
  final String? departmentId;
  final PolicyStatusFilter status;

  const PolicyFilter({
    this.region = PolicyRegion.all,
    this.province = '경상북도',
    this.city,
    this.district,
    this.category,
    this.isOnline,
    this.isOffline,
    this.age,
    this.tags = const [],
    this.institutionId,
    this.departmentId,
    this.status = PolicyStatusFilter.includeClosed,
  });

  bool? get isOngoing {
    switch (status) {
      case PolicyStatusFilter.inProgressOnly:
        return true;
      case PolicyStatusFilter.closedOnly:
        return false;
      case PolicyStatusFilter.includeClosed:
        return null;
    }
  }

  PolicyFilter normalize() {
    return PolicyFilter(
      region: region,
      province: province,
      city: city,
      district: district,
      category: category,
      isOnline: isOnline,
      isOffline: isOffline,
      age: age != null && age! > 0 ? age : null,
      tags: _normalizeTags(tags),
      institutionId: _normalizeId(institutionId),
      departmentId: _normalizeId(departmentId),
      status: status,
    );
  }

  PolicyFilter copyWith({
    PolicyRegion? region,
    String? province,
    String? city,
    String? district,
    PolicyCategory? category,
    bool? isOnline,
    bool? isOffline,
    int? age,
    List<String>? tags,
    String? institutionId,
    String? departmentId,
    PolicyStatusFilter? status,
  }) {
    return PolicyFilter(
      region: region ?? this.region,
      province: province ?? this.province,
      city: city ?? this.city,
      district: district ?? this.district,
      category: category ?? this.category,
      isOnline: isOnline ?? this.isOnline,
      isOffline: isOffline ?? this.isOffline,
      age: age ?? this.age,
      tags: tags ?? this.tags,
      institutionId: institutionId ?? this.institutionId,
      departmentId: departmentId ?? this.departmentId,
      status: status ?? this.status,
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
