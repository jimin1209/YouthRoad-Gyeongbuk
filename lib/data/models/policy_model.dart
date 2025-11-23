import '../../domain/entities/policy.dart';

class PolicyModel {
  const PolicyModel({
    required this.id,
    required this.policyNm,
    this.policyYr,
    this.rgnSeNm,
    this.policyTypeNm,
    this.sprvsnInstNm,
    this.operInstNm,
    this.policyBgngYmd,
    this.policyEndYmd,
    this.policyScl,
    this.policyCn,
    this.policyEnq,
    this.onlineApply,
    this.applyStart,
    this.applyEnd,
    this.isApplyNow,
    this.dtlLinkUrl,
    this.dsplyYn,
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
  });

  final String id; // no
  final String policyNm;
  final String? policyYr;
  final String? rgnSeNm;
  final String? policyTypeNm;
  final String? sprvsnInstNm;
  final String? operInstNm;
  final DateTime? policyBgngYmd;
  final DateTime? policyEndYmd;
  final String? policyScl;
  final String? policyCn;
  final String? policyEnq;
  final bool? onlineApply; // aplyYn
  final DateTime? applyStart; // aplyBgngDt
  final DateTime? applyEnd; // aplyEndDt
  final bool? isApplyNow; // aplyPsbltyYn
  final String? dtlLinkUrl;
  final String? dsplyYn;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> tags;

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
      rgnSeNm: _asNullableString(json['rgnSeNm']),
      policyTypeNm: _asNullableString(json['policyTypeNm']),
      sprvsnInstNm: _asNullableString(json['sprvsnInstNm']),
      operInstNm: _asNullableString(json['operInstNm']),
      policyBgngYmd: policyBgngYmd,
      policyEndYmd: policyEndYmd,
      policyScl: _asNullableString(json['policyScl']),
      policyCn: _asNullableString(json['policyCn']),
      policyEnq: _asNullableString(json['policyEnq']),
      onlineApply: _asBoolFromYn(json['aplyYn']),
      applyStart: applyStart,
      applyEnd: applyEnd,
      isApplyNow: _asBoolFromYn(json['aplyPsbltyYn']),
      dtlLinkUrl: _asNullableString(json['dtlLinkUrl']),
      dsplyYn: _asNullableString(json['dsplyYn']),
      createdAt: _parseDateTime(json['crtDt']),
      updatedAt: _parseDateTime(json['updtDt']),
      tags: const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'no': id,
        'policyNm': policyNm,
        'policyYr': policyYr,
        'rgnSeNm': rgnSeNm,
        'policyTypeNm': policyTypeNm,
        'sprvsnInstNm': sprvsnInstNm,
        'operInstNm': operInstNm,
        'policyBgngYmd': policyBgngYmd?.toIso8601String(),
        'policyEndYmd': policyEndYmd?.toIso8601String(),
        'policyScl': policyScl,
        'policyCn': policyCn,
        'policyEnq': policyEnq,
        'aplyYn': onlineApply == null
            ? null
            : onlineApply!
                ? 'Y'
                : 'N',
        'aplyBgngDt': applyStart?.toIso8601String(),
        'aplyEndDt': applyEnd?.toIso8601String(),
        'aplyPsbltyYn': isApplyNow == null
            ? null
            : isApplyNow!
                ? 'Y'
                : 'N',
        'dtlLinkUrl': dtlLinkUrl,
        'dsplyYn': dsplyYn,
        'crtDt': createdAt?.toIso8601String(),
        'updtDt': updatedAt?.toIso8601String(),
        'tags': tags,
      };

  Policy toEntity() {
    final calculatedDday = _calculateDday(policyEndYmd ?? applyEnd);
    final ongoing = _calculateIsOngoing(
      start: applyStart ?? policyBgngYmd,
      end: applyEnd ?? policyEndYmd,
      isApplyNow: isApplyNow,
    );

    return Policy(
      id: id,
      policyNm: policyNm,
      policyYr: policyYr,
      rgnSeNm: rgnSeNm,
      policyTypeNm: policyTypeNm,
      sprvsnInstNm: sprvsnInstNm,
      operInstNm: operInstNm,
      policyBgngYmd: policyBgngYmd,
      policyEndYmd: policyEndYmd,
      policyScl: policyScl,
      policyCn: policyCn,
      policyEnq: policyEnq,
      onlineApply: onlineApply,
      applyStart: applyStart,
      applyEnd: applyEnd,
      isApplyNow: isApplyNow,
      dtlLinkUrl: dtlLinkUrl,
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
    final text = _asNullableString(value);
    if (text == null || text.isEmpty) return null;
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
