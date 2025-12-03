import '../../domain/entities/policy.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_region.dart';

PolicyCategory _parseCategory(String? value) {
  if (value == null) return PolicyCategory.other;

  final normalized = value.toLowerCase();
  switch (normalized) {
    case 'employment':
    case '취업':
      return PolicyCategory.employment;
    case 'startup':
    case '창업':
      return PolicyCategory.startup;
    case 'housing':
    case '주거':
      return PolicyCategory.housing;
    case 'life':
    case '생활':
      return PolicyCategory.life;
    case 'education':
    case '교육':
      return PolicyCategory.education;
    case 'welfare':
    case '복지':
      return PolicyCategory.welfare;
    case 'culture':
    case '문화':
      return PolicyCategory.culture;
    default:
      return PolicyCategory.other;
  }
}

PolicyRegion _parseRegion(String? value) {
  if (value == null) return PolicyRegion.all;

  final normalized = value.toLowerCase();
  switch (normalized) {
    case '전체':
    case 'all':
      return PolicyRegion.all;
    case 'seoul':
    case '서울':
      return PolicyRegion.seoul;
    case 'busan':
    case '부산':
      return PolicyRegion.busan;
    case 'daegu':
    case '대구':
      return PolicyRegion.daegu;
    case 'incheon':
    case '인천':
      return PolicyRegion.incheon;
    case 'gwangju':
    case '광주':
      return PolicyRegion.gwangju;
    case 'daejeon':
    case '대전':
      return PolicyRegion.daejeon;
    case 'ulsan':
    case '울산':
      return PolicyRegion.ulsan;
    case 'gyeongbuk':
    case '경북':
    case '경상북도':
      return PolicyRegion.gyeongbuk;
    default:
      return PolicyRegion.all;
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) {
    final trimmed = value.trim();
    final numeric = num.tryParse(trimmed);
    if (numeric != null) {
      return _parseDate(numeric);
    }
  }
  if (value is num) {
    final timestamp = value.toInt();
    // 10자리 이하는 초 단위, 그 외는 밀리초 단위로 간주
    final millis = timestamp < 10000000000 ? timestamp * 1000 : timestamp;
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true).toLocal();
  }
  return DateTime.tryParse(value.toString());
}

class PolicyModel {
  final String id;
  final String title;
  final String summary;
  final String description;
  final PolicyRegion region;
  final PolicyCategory category;
  final List<String> tags;
  final List<String> keywords;
  final String? applicationStartDate;
  final String? applicationEndDate;
  final String? announceDate;
  final bool isOnline;
  final bool isOffline;
  final int? minAge;
  final int? maxAge;
  final bool isForYouth;
  final String? incomeCondition;
  final String? educationCondition;
  final String? employmentCondition;
  final String applyUrl;
  final String? attachmentUrl;
  final String institution;
  final String department;
  final String? contact;
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
    this.applicationStartDate,
    this.applicationEndDate,
    this.announceDate,
    required this.isOnline,
    required this.isOffline,
    this.minAge,
    this.maxAge,
    required this.isForYouth,
    this.incomeCondition,
    this.educationCondition,
    this.employmentCondition,
    required this.applyUrl,
    this.attachmentUrl,
    required this.institution,
    required this.department,
    this.contact,
    this.createdAt,
    this.updatedAt,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    List<String> _toStringList(dynamic value) {
      if (value is List) {
        return value
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      if (value is String && value.isNotEmpty) {
        return value
            .split(RegExp(r'[;,]'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return const [];
    }

    bool _toBool(dynamic value) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final normalized = value.toLowerCase();
        return normalized == 'y' ||
            normalized == 'yes' ||
            normalized == 'true' ||
            normalized == '1';
      }
      return false;
    }

    String? _firstNonEmpty(List<dynamic> candidates) {
      for (final candidate in candidates) {
        final value = candidate?.toString().trim();
        if (value != null && value.isNotEmpty) return value;
      }
      return null;
    }

    final rawRegion = _firstNonEmpty([
      json['region'],
      json['region_name'],
      json['region_kor'],
    ]);

    final rawCategory = _firstNonEmpty([
      json['category'],
      json['category_name'],
      json['category_kor'],
    ]);

    final tags = _toStringList(json['tags']);
    final keywords = _toStringList(json['keywords']);

    return PolicyModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString() ??
          json['description_short']?.toString() ??
          '',
      description: json['description']?.toString() ?? '',
      region: _parseRegion(rawRegion),
      category: _parseCategory(rawCategory),
      tags: tags,
      keywords: keywords.isNotEmpty ? keywords : tags,
      applicationStartDate:
          _firstNonEmpty([json['application_start_date'], json['apply_start']]),
      applicationEndDate:
          _firstNonEmpty([json['application_end_date'], json['apply_end']]),
      announceDate: _firstNonEmpty([json['announce_date'], json['announcement']]),
      isOnline: _toBool(json['is_online'] ?? json['apply_online']),
      isOffline: _toBool(json['is_offline'] ?? json['apply_offline']),
      minAge: json['min_age'] == null ? null : int.tryParse(json['min_age'].toString()),
      maxAge: json['max_age'] == null ? null : int.tryParse(json['max_age'].toString()),
      isForYouth: _toBool(json['is_for_youth'] ?? json['youth_only']),
      incomeCondition: _firstNonEmpty([json['income_condition'], json['income']]),
      educationCondition:
          _firstNonEmpty([json['education_condition'], json['education']]),
      employmentCondition:
          _firstNonEmpty([json['employment_condition'], json['employment']]),
      applyUrl: json['apply_url']?.toString() ?? '',
      attachmentUrl: json['attachment_url']?.toString(),
      institution: _firstNonEmpty([json['institution'], json['organization']]) ?? '',
      department: _firstNonEmpty([json['department'], json['division']]) ?? '',
      contact: _firstNonEmpty([json['contact'], json['contact_point']]),
      createdAt: _firstNonEmpty([json['created_at'], json['created']]),
      updatedAt: _firstNonEmpty([json['updated_at'], json['updated']]),
    );
  }

  Policy toDomain() {
    DateTime _parseRequiredDate(String? value) {
      return _parseDate(value) ?? DateTime.now();
    }

    String? _normalizeString(String? value) {
      if (value == null) return null;
      return value.isNotEmpty ? value : null;
    }

    return Policy(
      id: id,
      title: title,
      summary: summary,
      description: description,
      region: region,
      category: category,
      tags: tags,
      keywords: keywords,
      applicationStartDate: _parseDate(applicationStartDate),
      applicationEndDate: _parseDate(applicationEndDate),
      announceDate: _parseDate(announceDate),
      isOnline: isOnline,
      isOffline: isOffline,
      minAge: minAge,
      maxAge: maxAge,
      isForYouth: isForYouth,
      incomeCondition: _normalizeString(incomeCondition),
      educationCondition: _normalizeString(educationCondition),
      employmentCondition: _normalizeString(employmentCondition),
      applyUrl: applyUrl,
      attachmentUrl: _normalizeString(attachmentUrl),
      institution: institution,
      department: department,
      contact: _normalizeString(contact),
      createdAt: _parseRequiredDate(createdAt),
      updatedAt: _parseRequiredDate(updatedAt),
    );
  }
}
