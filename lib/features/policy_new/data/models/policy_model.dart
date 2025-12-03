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
  if (normalized.contains('경북') || normalized.contains('경상북')) {
    return PolicyRegion.gyeongbuk;
  }

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
    default:
      return PolicyRegion.all;
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty) return null;

  final digitsOnly = RegExp(r'^\d{8}$');
  if (digitsOnly.hasMatch(text)) {
    final year = int.tryParse(text.substring(0, 4));
    final month = int.tryParse(text.substring(4, 6));
    final day = int.tryParse(text.substring(6, 8));
    if (year != null && month != null && day != null) {
      return DateTime.tryParse('$year-${text.substring(4, 6)}-${text.substring(6, 8)}');
    }
  }

  return DateTime.tryParse(text);
}

bool? _asBoolFromYn(dynamic value) {
  final text = value?.toString().toUpperCase();
  if (text == null) return null;
  if (text == 'Y') return true;
  if (text == 'N') return false;
  return null;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  return value.toString();
}

class PolicyModel {
  final String id;
  final String name;
  final String? policyYear;
  final String? regionName;
  final String? typeName;
  final String? instName;
  final String? deptName;
  final String? supervisorName;
  final String? operatorName;
  final String? instNo;
  final String? deptNo;
  final String? policyScale;
  final String? policyContent;
  final String? inquiry;
  final bool? onlineApply;
  final DateTime? applyStart;
  final DateTime? applyEnd;
  final bool? applyPossible;
  final String? detailUrl;
  final String? displayYn;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PolicyModel({
    required this.id,
    required this.name,
    this.policyYear,
    this.regionName,
    this.typeName,
    this.instName,
    this.deptName,
    this.supervisorName,
    this.operatorName,
    this.instNo,
    this.deptNo,
    this.policyScale,
    this.policyContent,
    this.inquiry,
    this.onlineApply,
    this.applyStart,
    this.applyEnd,
    this.applyPossible,
    this.detailUrl,
    this.displayYn,
    this.createdAt,
    this.updatedAt,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    final idValue = _asNullableString(json['no']);
    final nameValue = _asNullableString(json['policyNm']);
    if (idValue == null || idValue.isEmpty) {
      throw StateError('정책 고유번호가 존재하지 않습니다');
    }
    if (nameValue == null || nameValue.isEmpty) {
      throw StateError('정책명이 존재하지 않습니다');
    }

    return PolicyModel(
      id: idValue,
      name: nameValue,
      policyYear: _asNullableString(json['policyYr']),
      regionName: _asNullableString(json['rgnSeNm']),
      typeName: _asNullableString(json['policyTypeNm']),
      instName: _asNullableString(json['instNm']),
      deptName: _asNullableString(json['deptNm']),
      supervisorName: _asNullableString(json['sprvsnInstNm']),
      operatorName: _asNullableString(json['operInstNm']),
      instNo: _asNullableString(json['instNo']),
      deptNo: _asNullableString(json['deptNo']),
      policyScale: _asNullableString(json['policyScl']),
      policyContent: _asNullableString(json['policyCn']),
      inquiry: _asNullableString(json['policyEnq']),
      onlineApply: _asBoolFromYn(json['aplyYn']),
      applyStart: _parseDate(json['aplyBgngDt']),
      applyEnd: _parseDate(json['aplyEndDt']),
      applyPossible: _asBoolFromYn(json['aplyPsbltyYn']),
      detailUrl: _asNullableString(json['dtlLinkUrl']),
      displayYn: _asNullableString(json['dsplyYn']),
      createdAt: _parseDate(json['crtDt']),
      updatedAt: _parseDate(json['updtDt']),
    );
  }

  Policy toDomain() {
    final summarySource = policyScale ?? policyContent ?? '';
    final summary = summarySource.isEmpty
        ? name
        : (summarySource.length > 120
            ? '${summarySource.substring(0, 120)}...'
            : summarySource);

    return Policy(
      id: id,
      title: name,
      summary: summary,
      description: policyContent ?? summary,
      region: _parseRegion(regionName),
      category: _parseCategory(typeName),
      tags: const [],
      keywords: const [],
      applicationStartDate: applyStart,
      applicationEndDate: applyEnd,
      announceDate: null,
      isOnline: onlineApply ?? true,
      isOffline: true,
      minAge: null,
      maxAge: null,
      isForYouth: true,
      incomeCondition: null,
      educationCondition: null,
      employmentCondition: null,
      applyUrl: detailUrl ?? '',
      attachmentUrl: null,
      institution: instName ?? supervisorName ?? '',
      department: deptName ?? operatorName ?? '',
      contact: inquiry,
      institutionId: instNo,
      departmentId: deptNo,
      detailUrl: detailUrl,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
