// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_youthcenter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentYouthcenterDtoImpl _$$ContentYouthcenterDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ContentYouthcenterDtoImpl(
      resultCode: (json['resultCode'] as num?)?.toInt(),
      resultMessage: json['resultMessage'] as String?,
      result: json['result'] == null
          ? null
          : ContentYouthcenterResultDto.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ContentYouthcenterDtoImplToJson(
        _$ContentYouthcenterDtoImpl instance) =>
    <String, dynamic>{
      'resultCode': instance.resultCode,
      'resultMessage': instance.resultMessage,
      'result': instance.result,
    };

_$ContentYouthcenterResultDtoImpl _$$ContentYouthcenterResultDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ContentYouthcenterResultDtoImpl(
      pagging: json['pagging'] == null
          ? null
          : ContentYouthcenterPaggingDto.fromJson(
              json['pagging'] as Map<String, dynamic>),
      youthPolicyList: (json['youthPolicyList'] as List<dynamic>?)
          ?.map((e) =>
              ContentYouthcenterItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ContentYouthcenterResultDtoImplToJson(
        _$ContentYouthcenterResultDtoImpl instance) =>
    <String, dynamic>{
      'pagging': instance.pagging,
      'youthPolicyList': instance.youthPolicyList,
    };

_$ContentYouthcenterPaggingDtoImpl _$$ContentYouthcenterPaggingDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ContentYouthcenterPaggingDtoImpl(
      totCount: (json['totCount'] as num?)?.toInt(),
      pageNum: (json['pageNum'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ContentYouthcenterPaggingDtoImplToJson(
        _$ContentYouthcenterPaggingDtoImpl instance) =>
    <String, dynamic>{
      'totCount': instance.totCount,
      'pageNum': instance.pageNum,
      'pageSize': instance.pageSize,
    };

_$ContentYouthcenterItemDtoImpl _$$ContentYouthcenterItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ContentYouthcenterItemDtoImpl(
      bbsSn: json['bbsSn'] as String?,
      pstSn: json['pstSn'] as String?,
      pstSeSn: json['pstSeSn'] as String?,
      pstSeNm: json['pstSeNm'] as String?,
      pstTtl: json['pstTtl'] as String?,
      pstWholCn: json['pstWholCn'] as String?,
      pstUrlAddr: json['pstUrlAddr'] as String?,
      atchFile: json['atchFile'] as String?,
      pstInqCnt: json['pstInqCnt'] as String?,
      frstRegDt: json['frstRegDt'] as String?,
      frstRgtrNm: json['frstRgtrNm'] as String?,
      lastMdfcnDt: json['lastMdfcnDt'] as String?,
      lastMdfrNm: json['lastMdfrNm'] as String?,
    );

Map<String, dynamic> _$$ContentYouthcenterItemDtoImplToJson(
        _$ContentYouthcenterItemDtoImpl instance) =>
    <String, dynamic>{
      'bbsSn': instance.bbsSn,
      'pstSn': instance.pstSn,
      'pstSeSn': instance.pstSeSn,
      'pstSeNm': instance.pstSeNm,
      'pstTtl': instance.pstTtl,
      'pstWholCn': instance.pstWholCn,
      'pstUrlAddr': instance.pstUrlAddr,
      'atchFile': instance.atchFile,
      'pstInqCnt': instance.pstInqCnt,
      'frstRegDt': instance.frstRegDt,
      'frstRgtrNm': instance.frstRgtrNm,
      'lastMdfcnDt': instance.lastMdfcnDt,
      'lastMdfrNm': instance.lastMdfrNm,
    };
