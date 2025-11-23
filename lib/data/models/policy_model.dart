import '../../domain/entities/policy.dart';

class PolicyModel {
  const PolicyModel({
    required this.id,
    required this.policyNm,
    this.policyYr,
    this.regionName,
    this.typeName,
    this.supervisorName,
    this.operatorName,
    this.startDate,
    this.endDate,
    this.policyScl,
    this.policyCn,
    this.policyEnq,
    this.onlineApply,
    this.applyStartDate,
    this.applyEndDate,
    this.isApplyPossible,
    this.detailUrl,
    this.dsplyYn,
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.dday,
    this.isOngoing,
  });

  final String id; // no
  final String policyNm;
  final String? policyYr;
  final String? regionName;
  final String? typeName;
  final String? supervisorName;
  final String? operatorName;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? policyScl;
  final String? policyCn;
  final String? policyEnq;
  final bool? onlineApply; // aplyYn
  final DateTime? applyStartDate; // aplyBgngDt
  final DateTime? applyEndDate; // aplyEndDt
  final bool? isApplyPossible; // aplyPsbltyYn
  final String? detailUrl;
  final String? dsplyYn;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> tags;
  final int? dday;
  final bool? isOngoing;

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    final policyBgngYmd = _parseDate(json['policyBgngYmd']);
    final policyEndYmd = _parseDate(json['policyEndYmd']);
    final applyStart = _parseDate(json['aplyBgngDt']);
    final applyEnd = _parseDate(json['aplyEndDt']);
    final id = _asNullableString(json['no']);
    final name = _asNullableString(json['policyNm']);

    if (id == null || id.isEmpty) {
      throw StateError('Policy id is missing');
    }
    if (name == null || name.isEmpty) {
      throw StateError('Policy name is missing');
    }

    return PolicyModel(
      id: id,
      policyNm: name,
      policyYr: _asNullableString(json['policyYr']),
      regionName: _asNullableString(json['rgnSeNm']),
      typeName: _asNullableString(json['policyTypeNm']),
      supervisorName: _asNullableString(json['sprvsnInstNm']),
      operatorName: _asNullableString(json['operInstNm']),
      startDate: policyBgngYmd,
      endDate: policyEndYmd,
      policyScl: _asNullableString(json['policyScl']),
      policyCn: _asNullableString(json['policyCn']),
      policyEnq: _asNullableString(json['policyEnq']),
      onlineApply: _asBoolFromYn(json['aplyYn']),
      applyStartDate: applyStart,
      applyEndDate: applyEnd,
      isApplyPossible: _asBoolFromYn(json['aplyPsbltyYn']),
      detailUrl: _asNullableString(json['dtlLinkUrl']),
      dsplyYn: _asNullableString(json['dsplyYn']),
      createdAt: _parseDateTime(json['crtDt']),
      updatedAt: _parseDateTime(json['updtDt']),
      tags: const [],
      dday: _calculateDday(policyEndYmd ?? applyEnd),
      isOngoing: _calculateIsOngoing(
        start: applyStart ?? policyBgngYmd,
        end: applyEnd ?? policyEndYmd,
        isApplyNow: _asBoolFromYn(json['aplyPsbltyYn']),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'no': id,
        'policyNm': policyNm,
        'policyYr': policyYr,
        'rgnSeNm': regionName,
        'policyTypeNm': typeName,
        'sprvsnInstNm': supervisorName,
        'operInstNm': operatorName,
        'policyBgngYmd': startDate?.toIso8601String(),
        'policyEndYmd': endDate?.toIso8601String(),
        'policyScl': policyScl,
        'policyCn': policyCn,
        'policyEnq': policyEnq,
        'aplyYn': onlineApply == null
            ? null
            : onlineApply!
                ? 'Y'
                : 'N',
        'aplyBgngDt': applyStartDate?.toIso8601String(),
        'aplyEndDt': applyEndDate?.toIso8601String(),
        'aplyPsbltyYn': isApplyPossible == null
            ? null
            : isApplyPossible!
                ? 'Y'
                : 'N',
        'dtlLinkUrl': detailUrl,
        'dsplyYn': dsplyYn,
        'crtDt': createdAt?.toIso8601String(),
        'updtDt': updatedAt?.toIso8601String(),
        'tags': tags,
        'dday': dday,
        'isOngoing': isOngoing,
      };

  Policy toEntity() {
    final calculatedDday = dday ?? _calculateDday(endDate ?? applyEndDate);
    final ongoing = isOngoing ?? _calculateIsOngoing(
      start: applyStartDate ?? startDate,
      end: applyEndDate ?? endDate,
      isApplyNow: isApplyPossible,
    );

    return Policy(
      id: id,
      policyNm: policyNm,
      policyYr: policyYr,
      rgnSeNm: regionName,
      policyTypeNm: typeName,
      sprvsnInstNm: supervisorName,
      operInstNm: operatorName,
      policyBgngYmd: startDate,
      policyEndYmd: endDate,
      policyScl: policyScl,
      policyCn: policyCn,
      policyEnq: policyEnq,
      onlineApply: onlineApply,
      applyStart: applyStartDate,
      applyEnd: applyEndDate,
      isApplyNow: isApplyPossible,
      dtlLinkUrl: detailUrl,
      dsplyYn: dsplyYn,
      createdAt: createdAt,
      updatedAt: updatedAt,
      tags: tags,
      dday: calculatedDday,
      isOngoing: ongoing,
    );
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

  static bool? _asBoolFromYn(dynamic value) {
    final text = _asNullableString(value)?.toUpperCase();
    if (text == null) return null;
    if (text == 'Y') return true;
    if (text == 'N') return false;
    return null;
  }

  static DateTime? _parseDate(dynamic value) {
    final text = _asNullableString(value)?.trim();
    if (text == null || text.isEmpty) return null;

    final digitsOnly = RegExp(r'^\d{8}$');
    final hyphenDate = RegExp(r'^\d{4}-\d{2}-\d{2}$');

    if (digitsOnly.hasMatch(text)) {
      final year = int.tryParse(text.substring(0, 4));
      final month = int.tryParse(text.substring(4, 6));
      final day = int.tryParse(text.substring(6, 8));
      if (year != null && month != null && day != null) {
        return DateTime.tryParse('$year-${text.substring(4, 6)}-${text.substring(6, 8)}');
      }
      return null;
    }

    if (hyphenDate.hasMatch(text)) {
      return DateTime.tryParse(text);
    }

    return DateTime.tryParse(text);
  }

  static DateTime? _parseDateTime(dynamic value) {
    final text = _asNullableString(value);
    if (text == null || text.isEmpty) return null;
    return DateTime.tryParse(text.replaceFirst(' ', 'T'));
  }

  static int? _calculateDday(DateTime? endDate) {
    if (endDate == null) return null;
    final now = DateTime.now();
    return endDate.difference(now).inDays;
  }

  static bool? _calculateIsOngoing({
    DateTime? start,
    DateTime? end,
    bool? isApplyNow,
  }) {
    if (isApplyNow != null) return isApplyNow;
    final now = DateTime.now();
    if (end != null && end.isBefore(now)) return false;
    if (start != null && start.isAfter(now)) return false;
    if (start != null || end != null) return true;
    return null;
  }
}
