import 'dart:math';

import 'region.dart';
import 'category.dart';

class Policy {
  final String id;
  final String title;
  final String summary;
  final String description;
  final String regionCode;
  final String regionName;
  final List<String> categories;
  final int minAge;
  final int maxAge;
  final List<String> targetGroups;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isOngoing;
  final String supportType;
  final String supportDetail;
  final String applicationMethod;
  final String applicationUrl;
  final String contact;
  final bool isNew;
  final int priority;

  Policy({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.regionCode,
    required this.regionName,
    required this.categories,
    required this.minAge,
    required this.maxAge,
    required this.targetGroups,
    this.startDate,
    this.endDate,
    required this.isOngoing,
    required this.supportType,
    required this.supportDetail,
    required this.applicationMethod,
    required this.applicationUrl,
    required this.contact,
    required this.isNew,
    required this.priority,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String? ?? '',
      description: json['description'] as String? ?? '',
      regionCode: json['regionCode'] as String,
      regionName: json['regionName'] as String? ?? '',
      categories: List<String>.from(json['categories'] ?? const []),
      minAge: json['minAge'] as int? ?? 0,
      maxAge: json['maxAge'] as int? ?? 0,
      targetGroups: List<String>.from(json['targetGroups'] ?? const []),
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      isOngoing: json['isOngoing'] as bool? ?? false,
      supportType: json['supportType'] as String? ?? '',
      supportDetail: json['supportDetail'] as String? ?? '',
      applicationMethod: json['applicationMethod'] as String? ?? '',
      applicationUrl: json['applicationUrl'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      isNew: json['isNew'] as bool? ?? false,
      priority: json['priority'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'description': description,
      'regionCode': regionCode,
      'regionName': regionName,
      'categories': categories,
      'minAge': minAge,
      'maxAge': maxAge,
      'targetGroups': targetGroups,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isOngoing': isOngoing,
      'supportType': supportType,
      'supportDetail': supportDetail,
      'applicationMethod': applicationMethod,
      'applicationUrl': applicationUrl,
      'contact': contact,
      'isNew': isNew,
      'priority': priority,
    };
  }
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
