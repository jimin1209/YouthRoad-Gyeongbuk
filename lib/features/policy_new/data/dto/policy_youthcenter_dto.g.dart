// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_youthcenter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PolicyYouthcenterDtoImpl _$$PolicyYouthcenterDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PolicyYouthcenterDtoImpl(
      resultCode: (json['resultCode'] as num?)?.toInt(),
      resultMessage: json['resultMessage'] as String?,
      result: json['result'] == null
          ? null
          : PolicyYouthcenterResultDto.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PolicyYouthcenterDtoImplToJson(
        _$PolicyYouthcenterDtoImpl instance) =>
    <String, dynamic>{
      'resultCode': instance.resultCode,
      'resultMessage': instance.resultMessage,
      'result': instance.result,
    };

_$PolicyYouthcenterResultDtoImpl _$$PolicyYouthcenterResultDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PolicyYouthcenterResultDtoImpl(
      pagging: json['pagging'] == null
          ? null
          : PolicyYouthcenterPaggingDto.fromJson(
              json['pagging'] as Map<String, dynamic>),
      youthPolicyList: (json['youthPolicyList'] as List<dynamic>?)
          ?.map((e) =>
              PolicyYouthcenterItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PolicyYouthcenterResultDtoImplToJson(
        _$PolicyYouthcenterResultDtoImpl instance) =>
    <String, dynamic>{
      'pagging': instance.pagging,
      'youthPolicyList': instance.youthPolicyList,
    };

_$PolicyYouthcenterPaggingDtoImpl _$$PolicyYouthcenterPaggingDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PolicyYouthcenterPaggingDtoImpl(
      totCount: (json['totCount'] as num?)?.toInt(),
      pageNum: (json['pageNum'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PolicyYouthcenterPaggingDtoImplToJson(
        _$PolicyYouthcenterPaggingDtoImpl instance) =>
    <String, dynamic>{
      'totCount': instance.totCount,
      'pageNum': instance.pageNum,
      'pageSize': instance.pageSize,
    };

_$PolicyYouthcenterItemDtoImpl _$$PolicyYouthcenterItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PolicyYouthcenterItemDtoImpl(
      plcyNo: json['plcyNo'] as String?,
      bscPlanCycl: json['bscPlanCycl'] as String?,
      bscPlanPlcyWayNo: json['bscPlanPlcyWayNo'] as String?,
      bscPlanFcsAsmtNo: json['bscPlanFcsAsmtNo'] as String?,
      bscPlanAsmtNo: json['bscPlanAsmtNo'] as String?,
      pvsnInstGroupCd: json['pvsnInstGroupCd'] as String?,
      plcyPvsnMthdCd: json['plcyPvsnMthdCd'] as String?,
      plcyAprvSttsCd: json['plcyAprvSttsCd'] as String?,
      plcyNm: json['plcyNm'] as String?,
      plcyKywdNm: json['plcyKywdNm'] as String?,
      plcyExplnCn: json['plcyExplnCn'] as String?,
      lclsfNm: json['lclsfNm'] as String?,
      mclsfNm: json['mclsfNm'] as String?,
      plcySprtCn: json['plcySprtCn'] as String?,
      sprvsnInstCd: json['sprvsnInstCd'] as String?,
      sprvsnInstCdNm: json['sprvsnInstCdNm'] as String?,
      sprvsnInstPicNm: json['sprvsnInstPicNm'] as String?,
      operInstCd: json['operInstCd'] as String?,
      operInstCdNm: json['operInstCdNm'] as String?,
      operInstPicNm: json['operInstPicNm'] as String?,
      sprtSclLmtYn: json['sprtSclLmtYn'] as String?,
      aplyPrdSeCd: json['aplyPrdSeCd'] as String?,
      bizPrdSeCd: json['bizPrdSeCd'] as String?,
      bizPrdBgngYmd: json['bizPrdBgngYmd'] as String?,
      bizPrdEndYmd: json['bizPrdEndYmd'] as String?,
      bizPrdEtcCn: json['bizPrdEtcCn'] as String?,
      plcyAplyMthdCn: json['plcyAplyMthdCn'] as String?,
      srngMthdCn: json['srngMthdCn'] as String?,
      aplyUrlAddr: json['aplyUrlAddr'] as String?,
      aplyYmd: json['aplyYmd'] as String?,
      earnCndSeCd: json['earnCndSeCd'] as String?,
      earnMinAmt: json['earnMinAmt'] as String?,
      earnMaxAmt: json['earnMaxAmt'] as String?,
      earnEtcCn: json['earnEtcCn'] as String?,
      sprtSclCnt: json['sprtSclCnt'] as String?,
      sprtTrgtAgeLmtYn: json['sprtTrgtAgeLmtYn'] as String?,
      sprtTrgtMinAge: json['sprtTrgtMinAge'] as String?,
      sprtTrgtMaxAge: json['sprtTrgtMaxAge'] as String?,
      sprtArvlSeqYn: json['sprtArvlSeqYn'] as String?,
      sbizCd: json['sbizCd'] as String?,
      schoolCd: json['schoolCd'] as String?,
      jobCd: json['jobCd'] as String?,
      mrgSttsCd: json['mrgSttsCd'] as String?,
      ptcpPrpTrgtCn: json['ptcpPrpTrgtCn'] as String?,
      addAplyQlfcCndCn: json['addAplyQlfcCndCn'] as String?,
      etcMttrCn: json['etcMttrCn'] as String?,
      refUrlAddr1: json['refUrlAddr1'] as String?,
      refUrlAddr2: json['refUrlAddr2'] as String?,
      sbmsnDcmntCn: json['sbmsnDcmntCn'] as String?,
      plcyMajorCd: json['plcyMajorCd'] as String?,
      rgtrHghrkInstCd: json['rgtrHghrkInstCd'] as String?,
      rgtrHghrkInstCdNm: json['rgtrHghrkInstCdNm'] as String?,
      rgtrInstCd: json['rgtrInstCd'] as String?,
      rgtrInstCdNm: json['rgtrInstCdNm'] as String?,
      rgtrUpInstCd: json['rgtrUpInstCd'] as String?,
      rgtrUpInstCdNm: json['rgtrUpInstCdNm'] as String?,
      frstRegDt: json['frstRegDt'] as String?,
      lastMdfcnDt: json['lastMdfcnDt'] as String?,
      inqCnt: json['inqCnt'] as String?,
      zipCd: json['zipCd'] as String?,
    );

Map<String, dynamic> _$$PolicyYouthcenterItemDtoImplToJson(
        _$PolicyYouthcenterItemDtoImpl instance) =>
    <String, dynamic>{
      'plcyNo': instance.plcyNo,
      'bscPlanCycl': instance.bscPlanCycl,
      'bscPlanPlcyWayNo': instance.bscPlanPlcyWayNo,
      'bscPlanFcsAsmtNo': instance.bscPlanFcsAsmtNo,
      'bscPlanAsmtNo': instance.bscPlanAsmtNo,
      'pvsnInstGroupCd': instance.pvsnInstGroupCd,
      'plcyPvsnMthdCd': instance.plcyPvsnMthdCd,
      'plcyAprvSttsCd': instance.plcyAprvSttsCd,
      'plcyNm': instance.plcyNm,
      'plcyKywdNm': instance.plcyKywdNm,
      'plcyExplnCn': instance.plcyExplnCn,
      'lclsfNm': instance.lclsfNm,
      'mclsfNm': instance.mclsfNm,
      'plcySprtCn': instance.plcySprtCn,
      'sprvsnInstCd': instance.sprvsnInstCd,
      'sprvsnInstCdNm': instance.sprvsnInstCdNm,
      'sprvsnInstPicNm': instance.sprvsnInstPicNm,
      'operInstCd': instance.operInstCd,
      'operInstCdNm': instance.operInstCdNm,
      'operInstPicNm': instance.operInstPicNm,
      'sprtSclLmtYn': instance.sprtSclLmtYn,
      'aplyPrdSeCd': instance.aplyPrdSeCd,
      'bizPrdSeCd': instance.bizPrdSeCd,
      'bizPrdBgngYmd': instance.bizPrdBgngYmd,
      'bizPrdEndYmd': instance.bizPrdEndYmd,
      'bizPrdEtcCn': instance.bizPrdEtcCn,
      'plcyAplyMthdCn': instance.plcyAplyMthdCn,
      'srngMthdCn': instance.srngMthdCn,
      'aplyUrlAddr': instance.aplyUrlAddr,
      'aplyYmd': instance.aplyYmd,
      'earnCndSeCd': instance.earnCndSeCd,
      'earnMinAmt': instance.earnMinAmt,
      'earnMaxAmt': instance.earnMaxAmt,
      'earnEtcCn': instance.earnEtcCn,
      'sprtSclCnt': instance.sprtSclCnt,
      'sprtTrgtAgeLmtYn': instance.sprtTrgtAgeLmtYn,
      'sprtTrgtMinAge': instance.sprtTrgtMinAge,
      'sprtTrgtMaxAge': instance.sprtTrgtMaxAge,
      'sprtArvlSeqYn': instance.sprtArvlSeqYn,
      'sbizCd': instance.sbizCd,
      'schoolCd': instance.schoolCd,
      'jobCd': instance.jobCd,
      'mrgSttsCd': instance.mrgSttsCd,
      'ptcpPrpTrgtCn': instance.ptcpPrpTrgtCn,
      'addAplyQlfcCndCn': instance.addAplyQlfcCndCn,
      'etcMttrCn': instance.etcMttrCn,
      'refUrlAddr1': instance.refUrlAddr1,
      'refUrlAddr2': instance.refUrlAddr2,
      'sbmsnDcmntCn': instance.sbmsnDcmntCn,
      'plcyMajorCd': instance.plcyMajorCd,
      'rgtrHghrkInstCd': instance.rgtrHghrkInstCd,
      'rgtrHghrkInstCdNm': instance.rgtrHghrkInstCdNm,
      'rgtrInstCd': instance.rgtrInstCd,
      'rgtrInstCdNm': instance.rgtrInstCdNm,
      'rgtrUpInstCd': instance.rgtrUpInstCd,
      'rgtrUpInstCdNm': instance.rgtrUpInstCdNm,
      'frstRegDt': instance.frstRegDt,
      'lastMdfcnDt': instance.lastMdfcnDt,
      'inqCnt': instance.inqCnt,
      'zipCd': instance.zipCd,
    };
