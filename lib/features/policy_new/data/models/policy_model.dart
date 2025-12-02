import '../../domain/entities/policy.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_region.dart';
import '../../domain/values/policy_sort.dart';

PolicyCategory _parseCategory(String? value) {
  switch (value) {
    case 'employment':
      return PolicyCategory.employment;
    case 'startup':
      return PolicyCategory.startup;
    case 'housing':
      return PolicyCategory.housing;
    case 'life':
      return PolicyCategory.life;
    case 'education':
      return PolicyCategory.education;
    case 'welfare':
      return PolicyCategory.welfare;
    case 'culture':
      return PolicyCategory.culture;
    default:
      return PolicyCategory.other;
  }
}

PolicyRegion _parseRegion(String? value) {
  return PolicyRegion.values
      .firstWhere((e) => e.name == value, orElse: () => PolicyRegion.all);
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

class PolicyModel {
  final String id;
  final String title;
  final String summary;
  final String description;
  final String region;
  final String category;
  final List<String> tags;
  final List<String> keywords;
  final String? startDate;
  final String? endDate;
  final String? announceDate;
  final bool isOnline;
  final bool isOffline;
  final int? minAge;
  final int? maxAge;
  final bool isForYouth;
  final String incomeCondition;
  final String educationCondition;
  final String employmentCondition;
  final String applyUrl;
  final String attachmentUrl;
  final String institution;
  final String department;
  final String contact;
  final String? createdAt;
  final String? updatedAt;

  PolicyModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.region,
    required this.category,
    required this.tags,
    required this.keywords,
    this.startDate,
    this.endDate,
    this.announceDate,
    required this.isOnline,
    required this.isOffline,
    this.minAge,
    this.maxAge,
    required this.isForYouth,
    required this.incomeCondition,
    required this.educationCondition,
    required this.employmentCondition,
    required this.applyUrl,
    required this.attachmentUrl,
    required this.institution,
    required this.department,
    required this.contact,
    this.createdAt,
    this.updatedAt,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      region: json['region']?.toString() ?? 'all',
      category: json['category']?.toString() ?? 'other',
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      keywords:
          (json['keywords'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      startDate: json['application_start_date']?.toString(),
      endDate: json['application_end_date']?.toString(),
      announceDate: json['announce_date']?.toString(),
      isOnline: json['is_online'] as bool? ?? true,
      isOffline: json['is_offline'] as bool? ?? true,
      minAge: json['min_age'] as int?,
      maxAge: json['max_age'] as int?,
      isForYouth: json['is_for_youth'] as bool? ?? true,
      incomeCondition: json['income_condition']?.toString() ?? '',
      educationCondition: json['education_condition']?.toString() ?? '',
      employmentCondition: json['employment_condition']?.toString() ?? '',
      applyUrl: json['apply_url']?.toString() ?? '',
      attachmentUrl: json['attachment_url']?.toString() ?? '',
      institution: json['institution']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      contact: json['contact']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Policy toDomain() {
    return Policy(
      id: id,
      title: title,
      summary: summary,
      description: description.isNotEmpty ? description : summary,
      region: _parseRegion(region),
      category: _parseCategory(category),
      tags: tags,
      keywords: keywords,
      applicationStartDate: _parseDate(startDate),
      applicationEndDate: _parseDate(endDate),
      announceDate: _parseDate(announceDate),
      isOnline: isOnline,
      isOffline: isOffline,
      minAge: minAge,
      maxAge: maxAge,
      isForYouth: isForYouth,
      incomeCondition: incomeCondition,
      educationCondition: educationCondition,
      employmentCondition: employmentCondition,
      applyUrl: applyUrl,
      attachmentUrl: attachmentUrl,
      institution: institution,
      department: department,
      contact: contact,
      createdAt: _parseDate(createdAt),
      updatedAt: _parseDate(updatedAt),
    );
  }
}
