import '../../domain/entities/policy.dart';

class PolicyModel {
  const PolicyModel({
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

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    final List<String> parsedTags =
        (json['tags'] as List<dynamic>?)?.map(_asString).toList() ?? const [];

    return PolicyModel(
      id: _asString(json['id']),
      title: _asString(json['title']),
      category: _asString(json['category']),
      summary: _asString(json['summary']),
      tags: parsedTags,
      policyUrl: _asNullableString(json['policyUrl']),
      agency: _asNullableString(json['agency']),
      department: _asNullableString(json['department']),
      eligibilityAge: _asInt(json['eligibilityAge']),
      eligibilityRegion: _asNullableString(json['eligibilityRegion']),
      applicationMethod: _asNullableString(json['applicationMethod']),
      requiredDocuments: _asNullableString(json['requiredDocuments']),
      contact: _asNullableString(json['contact']),
      periodStart: _asNullableString(json['periodStart']),
      periodEnd: _asNullableString(json['periodEnd']),
      dday: _asInt(json['dday']),
      isOngoing: _asBool(json['isOngoing']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'summary': summary,
        'tags': tags,
        'policyUrl': policyUrl,
        'agency': agency,
        'department': department,
        'eligibilityAge': eligibilityAge,
        'eligibilityRegion': eligibilityRegion,
        'applicationMethod': applicationMethod,
        'requiredDocuments': requiredDocuments,
        'contact': contact,
        'periodStart': periodStart,
        'periodEnd': periodEnd,
        'dday': dday,
        'isOngoing': isOngoing,
      };

  Policy toEntity() => Policy(
        id: id,
        title: title,
        category: category,
        summary: summary,
        tags: tags,
        policyUrl: policyUrl,
        agency: agency,
        department: department,
        eligibilityAge: eligibilityAge,
        eligibilityRegion: eligibilityRegion,
        applicationMethod: applicationMethod,
        requiredDocuments: requiredDocuments,
        contact: contact,
        periodStart: periodStart,
        periodEnd: periodEnd,
        dday: dday,
        isOngoing: isOngoing,
      );

  static int? _asInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static bool? _asBool(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == '1') {
        return true;
      }
      if (lower == 'false' || lower == '0') {
        return false;
      }
    }
    return null;
  }

  static String _asString(dynamic value) {
    if (value == null) {
      return '';
    }
    if (value is String) {
      return value;
    }
    return value.toString();
  }

  static String? _asNullableString(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    }
    return value.toString();
  }
}
