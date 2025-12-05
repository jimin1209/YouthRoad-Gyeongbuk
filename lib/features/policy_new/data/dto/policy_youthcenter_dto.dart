// SOURCE: docs/청년정책API.json
// GENERATED_AT: 2025-12-05
// API_SN: 86
// PURPOSE: External data preservation (contract level)

import 'package:freezed_annotation/freezed_annotation.dart';

part 'policy_youthcenter_dto.freezed.dart';
part 'policy_youthcenter_dto.g.dart';

@freezed
class PolicyYouthcenterDto with _$PolicyYouthcenterDto {
  const factory PolicyYouthcenterDto({
    final int? resultCode,
    final String? resultMessage,
    final PolicyYouthcenterResultDto? result,
  }) = _PolicyYouthcenterDto;

  factory PolicyYouthcenterDto.fromJson(Map<String, dynamic> json) =>
      _$PolicyYouthcenterDtoFromJson(json);
}

@freezed
class PolicyYouthcenterResultDto with _$PolicyYouthcenterResultDto {
  const factory PolicyYouthcenterResultDto({
    final PolicyYouthcenterPaggingDto? pagging,
    final List<PolicyYouthcenterItemDto>? youthPolicyList,
  }) = _PolicyYouthcenterResultDto;

  factory PolicyYouthcenterResultDto.fromJson(Map<String, dynamic> json) =>
      _$PolicyYouthcenterResultDtoFromJson(json);
}

@freezed
class PolicyYouthcenterPaggingDto with _$PolicyYouthcenterPaggingDto {
  const factory PolicyYouthcenterPaggingDto({
    final int? totCount,
    final int? pageNum,
    final int? pageSize,
  }) = _PolicyYouthcenterPaggingDto;

  factory PolicyYouthcenterPaggingDto.fromJson(Map<String, dynamic> json) =>
      _$PolicyYouthcenterPaggingDtoFromJson(json);
}

@freezed
class PolicyYouthcenterItemDto with _$PolicyYouthcenterItemDto {
  const factory PolicyYouthcenterItemDto({
    final String? plcyNo,
    final String? bscPlanCycl,
    final String? bscPlanPlcyWayNo,
    final String? bscPlanFcsAsmtNo,
    final String? bscPlanAsmtNo,
    final String? pvsnInstGroupCd,
    final String? plcyPvsnMthdCd,
    final String? plcyAprvSttsCd,
    final String? plcyNm,
    final String? plcyKywdNm,
    final String? plcyExplnCn,
    final String? lclsfNm,
    final String? mclsfNm,
    final String? plcySprtCn,
    final String? sprvsnInstCd,
    final String? sprvsnInstCdNm,
    final String? sprvsnInstPicNm,
    final String? operInstCd,
    final String? operInstCdNm,
    final String? operInstPicNm,
    final String? sprtSclLmtYn,
    final String? aplyPrdSeCd,
    final String? bizPrdSeCd,
    final String? bizPrdBgngYmd,
    final String? bizPrdEndYmd,
    final String? bizPrdEtcCn,
    final String? plcyAplyMthdCn,
    final String? srngMthdCn,
    final String? aplyUrlAddr,
    final String? aplyYmd,
    final String? earnCndSeCd,
    final String? earnMinAmt,
    final String? earnMaxAmt,
    final String? earnEtcCn,
    final String? sprtSclCnt,
    final String? sprtTrgtAgeLmtYn,
    final String? sprtTrgtMinAge,
    final String? sprtTrgtMaxAge,
    final String? sprtArvlSeqYn,
    final String? sbizCd,
    final String? schoolCd,
    final String? jobCd,
    final String? mrgSttsCd,
    final String? ptcpPrpTrgtCn,
    final String? addAplyQlfcCndCn,
    final String? etcMttrCn,
    final String? refUrlAddr1,
    final String? refUrlAddr2,
    final String? sbmsnDcmntCn,
    final String? plcyMajorCd,
    final String? rgtrHghrkInstCd,
    final String? rgtrHghrkInstCdNm,
    final String? rgtrInstCd,
    final String? rgtrInstCdNm,
    final String? rgtrUpInstCd,
    final String? rgtrUpInstCdNm,
    final String? frstRegDt,
    final String? lastMdfcnDt,
    final String? inqCnt,
    final String? zipCd,
  }) = _PolicyYouthcenterItemDto;

  factory PolicyYouthcenterItemDto.fromJson(Map<String, dynamic> json) =>
      _$PolicyYouthcenterItemDtoFromJson(json);
}
