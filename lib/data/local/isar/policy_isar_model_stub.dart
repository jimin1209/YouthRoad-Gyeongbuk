import '../../../domain/entities/policy.dart';
import '../../models/policy_model.dart';

class PolicyIsarModel {
  PolicyIsarModel({
    this.isarId,
    required this.policyId,
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
    this.dday,
    this.isOngoing,
  });

  int? isarId;
  String policyId;
  String policyNm;
  String? policyYr;
  String? rgnSeNm;
  String? policyTypeNm;
  String? sprvsnInstNm;
  String? operInstNm;
  DateTime? policyBgngYmd;
  DateTime? policyEndYmd;
  String? policyScl;
  String? policyCn;
  String? policyEnq;
  bool? onlineApply;
  DateTime? applyStart;
  DateTime? applyEnd;
  bool? isApplyNow;
  String? dtlLinkUrl;
  String? dsplyYn;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> tags;
  int? dday;
  bool? isOngoing;

  factory PolicyIsarModel.fromApi(PolicyModel model) {
    return PolicyIsarModel(
      policyId: model.id,
      policyNm: model.policyNm,
      policyYr: model.policyYr,
      rgnSeNm: model.regionName,
      policyTypeNm: model.typeName,
      sprvsnInstNm: model.supervisorName,
      operInstNm: model.operatorName,
      policyBgngYmd: model.startDate,
      policyEndYmd: model.endDate,
      policyScl: model.policyScl,
      policyCn: model.policyCn,
      policyEnq: model.policyEnq,
      onlineApply: model.onlineApply,
      applyStart: model.applyStartDate,
      applyEnd: model.applyEndDate,
      isApplyNow: model.isApplyPossible,
      dtlLinkUrl: model.detailUrl,
      dsplyYn: model.dsplyYn,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      tags: model.tags,
      dday: model.dday,
      isOngoing: model.isOngoing,
    );
  }

  factory PolicyIsarModel.fromDomain(Policy policy) {
    return PolicyIsarModel(
      policyId: policy.id,
      policyNm: policy.policyNm,
      policyYr: policy.policyYr,
      rgnSeNm: policy.rgnSeNm,
      policyTypeNm: policy.policyTypeNm,
      sprvsnInstNm: policy.sprvsnInstNm,
      operInstNm: policy.operInstNm,
      policyBgngYmd: policy.policyBgngYmd,
      policyEndYmd: policy.policyEndYmd,
      policyScl: policy.policyScl,
      policyCn: policy.policyCn,
      policyEnq: policy.policyEnq,
      onlineApply: policy.onlineApply,
      applyStart: policy.applyStart,
      applyEnd: policy.applyEnd,
      isApplyNow: policy.isApplyNow,
      dtlLinkUrl: policy.dtlLinkUrl,
      dsplyYn: policy.dsplyYn,
      createdAt: policy.createdAt,
      updatedAt: policy.updatedAt,
      tags: policy.tags,
      dday: policy.dday,
      isOngoing: policy.isOngoing,
    );
  }

  Policy toDomain() {
    return Policy(
      id: policyId,
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
      dday: dday,
      isOngoing: isOngoing,
    );
  }
}
