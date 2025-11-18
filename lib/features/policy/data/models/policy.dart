import 'dart:math';

import '../../../../core/api/models/policy.dart' as remote;
import 'region.dart';
import 'category.dart';

class Policy {
  Policy({
    required this.id,
    required this.policyName,
    this.policyType,
    this.region,
    this.institutionName,
    this.departmentName,
    String? description,
    this.startDate,
    this.endDate,
    this.applyUrl,
    this.displayYn = 'Y',
    List<String>? categories,
    int? minAge,
    int? maxAge,
    List<String>? targetGroups,
    String? supportType,
    String? supportDetail,
    String? applicationMethod,
    String? contact,
    bool? isNew,
    int? priority,
  })  : description = description ?? '',
        categories = List.unmodifiable(categories ?? const []),
        minAge = minAge ?? 0,
        maxAge = maxAge ?? 0,
        targetGroups = List.unmodifiable(targetGroups ?? const []),
        supportType = supportType ?? '',
        supportDetail = supportDetail ?? '',
        applicationMethod = applicationMethod ?? '',
        contact = contact ?? '',
        isNew = isNew ?? false,
        priority = priority ?? 0;

  final String id;
  final String policyName;
  final String? policyType;
  final String? region;
  final String? institutionName;
  final String? departmentName;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? applyUrl;
  final String displayYn;

  final List<String> categories;
  final int minAge;
  final int maxAge;
  final List<String> targetGroups;
  final String supportType;
  final String supportDetail;
  final String applicationMethod;
  final String contact;
  final bool isNew;
  final int priority;

  String get title => policyName;
  String get summary => description ?? '';
  String get regionCode => region ?? '';
  String get regionName => region ?? '';
  String get applicationUrl => applyUrl ?? '';
  bool get isOngoing => displayYn.toUpperCase() == 'Y';

  factory Policy.fromRemote(remote.Policy remotePolicy) {
    final start = _parseDate(remotePolicy.startDate);
    final end = _parseDate(remotePolicy.endDate);
    final derivedCategories = <String>[];
    if (remotePolicy.policyType?.isNotEmpty ?? false) {
      derivedCategories.add(remotePolicy.policyType!);
    }
    return Policy(
      id: remotePolicy.id ?? (remotePolicy.policyName ?? ''),
      policyName: remotePolicy.policyName ?? '',
      policyType: remotePolicy.policyType,
      region: remotePolicy.region,
      institutionName: remotePolicy.institutionName,
      departmentName: remotePolicy.departmentName,
      description: remotePolicy.description,
      startDate: start,
      endDate: end,
      applyUrl: remotePolicy.applyUrl,
      displayYn: remotePolicy.displayYn ?? 'Y',
      categories: derivedCategories,
      supportType: remotePolicy.policyType ?? '',
      supportDetail: remotePolicy.description ?? '',
      applicationMethod:
          remotePolicy.applyUrl?.isNotEmpty ?? false ? '온라인 접수' : '',
      contact: remotePolicy.institutionName ?? '',
      isNew: _isRecent(start),
      priority: _priorityFromDates(start, end),
    );
  }

  factory Policy.fromJson(Map<String, dynamic> json) {
    final start = _parseDate(json['startDate'] as String?);
    final end = _parseDate(json['endDate'] as String?);
    final storedCategories = _stringList(json['categories']);
    final inferredPolicyType =
        json['policyType'] as String? ?? (storedCategories.isNotEmpty ? storedCategories.first : null);
    final region = json['region'] as String? ?? json['regionCode'] as String?;
    final applyUrl = json['applyUrl'] as String? ?? json['applicationUrl'] as String?;
    final description = json['description'] as String? ?? json['summary'] as String?;
    final displayYn = json['displayYn'] as String? ??
        ((json['isOngoing'] as bool? ?? true) ? 'Y' : 'N');
    final categories = storedCategories.isNotEmpty
        ? storedCategories
        : (inferredPolicyType == null ? const <String>[] : <String>[inferredPolicyType]);
    return Policy(
      id: (json['id'] ?? json['policyId'] ?? '').toString(),
      policyName: json['policyName'] as String? ?? json['title'] as String? ?? '',
      policyType: inferredPolicyType,
      region: region,
      institutionName: json['institutionName'] as String? ?? json['institution'] as String?,
      departmentName: json['departmentName'] as String?,
      description: description,
      startDate: start,
      endDate: end,
      applyUrl: applyUrl,
      displayYn: displayYn,
      categories: categories,
      minAge: _asInt(json['minAge']) ?? 0,
      maxAge: _asInt(json['maxAge']) ?? 0,
      targetGroups: _stringList(json['targetGroups']),
      supportType: json['supportType'] as String? ?? inferredPolicyType ?? '',
      supportDetail: json['supportDetail'] as String? ?? description ?? '',
      applicationMethod: json['applicationMethod'] as String? ??
          (applyUrl != null && applyUrl.isNotEmpty ? '온라인 접수' : ''),
      contact: json['contact'] as String? ?? json['institutionName'] as String? ?? '',
      isNew: json['isNew'] as bool? ?? _isRecent(start),
      priority: _asInt(json['priority']) ?? _priorityFromDates(start, end),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'policyName': policyName,
      'policyType': policyType,
      'region': region,
      'institutionName': institutionName,
      'departmentName': departmentName,
      'description': description,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'applyUrl': applyUrl,
      'displayYn': displayYn,
      'categories': categories,
      'minAge': minAge,
      'maxAge': maxAge,
      'targetGroups': targetGroups,
      'supportType': supportType,
      'supportDetail': supportDetail,
      'applicationMethod': applicationMethod,
      'contact': contact,
      'isNew': isNew,
      'priority': priority,
    };
  }
}

DateTime? _parseDate(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  return DateTime.tryParse(value);
}

bool _isRecent(DateTime? start) {
  if (start == null) {
    return false;
  }
  return DateTime.now().difference(start).inDays <= 14;
}

int _priorityFromDates(DateTime? start, DateTime? end) {
  if (end == null) {
    return 0;
  }
  final remaining = end.difference(DateTime.now()).inDays;
  if (remaining < 0) {
    return 0;
  }
  return max(0, 30 - remaining);
}

int? _asInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value.toString());
}

List<String> _stringList(dynamic value) {
  if (value == null) {
    return const [];
  }
  if (value is List) {
    return value.map((e) => e.toString()).where((element) => element.isNotEmpty).toList();
  }
  if (value is String) {
    return value
        .split(',')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }
  return const [];
}

/// Helper to compute recommendation score based on user interests and policy metadata.
double computePolicyScore(
  Policy policy,
  List<String> userInterests, {
  String? preferredRegion,
  Set<String>? recentPolicyIds,
  Set<String>? bookmarkedIds,
  Map<String, int>? clickCounts,
}) {
  double score = policy.priority.toDouble();
  final overlap = policy.categories.where(userInterests.contains).length;
  score += overlap * 12;

  if (preferredRegion != null && policy.regionCode == preferredRegion) {
    score += 18;
  }

  if (policy.endDate != null) {
    final daysLeft = policy.endDate!.difference(DateTime.now()).inDays;
    if (daysLeft >= 0 && daysLeft <= 7) {
      score += 25;
    } else if (daysLeft <= 30) {
      score += 12;
    }
  }

  if (policy.isNew) {
    score += 15;
  }

  if (recentPolicyIds?.contains(policy.id) ?? false) {
    score += 8;
  }

  if (bookmarkedIds?.contains(policy.id) ?? false) {
    score += 30;
  }

  if (clickCounts != null && clickCounts.containsKey(policy.id)) {
    final clicks = clickCounts[policy.id] ?? 0;
    score += min(clicks, 5) * 3;
  }

  return score;
}
