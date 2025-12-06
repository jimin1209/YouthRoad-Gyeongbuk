// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'center_youthcenter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CenterYouthcenterDtoImpl _$$CenterYouthcenterDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CenterYouthcenterDtoImpl(
      resultCode: (json['resultCode'] as num?)?.toInt(),
      resultMessage: json['resultMessage'] as String?,
      result: json['result'] == null
          ? null
          : CenterYouthcenterResultDto.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CenterYouthcenterDtoImplToJson(
        _$CenterYouthcenterDtoImpl instance) =>
    <String, dynamic>{
      'resultCode': instance.resultCode,
      'resultMessage': instance.resultMessage,
      'result': instance.result,
    };

_$CenterYouthcenterResultDtoImpl _$$CenterYouthcenterResultDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CenterYouthcenterResultDtoImpl(
      pagging: json['pagging'] == null
          ? null
          : CenterYouthcenterPaggingDto.fromJson(
              json['pagging'] as Map<String, dynamic>),
      youthPolicyList: (json['youthPolicyList'] as List<dynamic>?)
          ?.map((e) =>
              CenterYouthcenterItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CenterYouthcenterResultDtoImplToJson(
        _$CenterYouthcenterResultDtoImpl instance) =>
    <String, dynamic>{
      'pagging': instance.pagging,
      'youthPolicyList': instance.youthPolicyList,
    };

_$CenterYouthcenterPaggingDtoImpl _$$CenterYouthcenterPaggingDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CenterYouthcenterPaggingDtoImpl(
      totCount: (json['totCount'] as num?)?.toInt(),
      pageNum: (json['pageNum'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CenterYouthcenterPaggingDtoImplToJson(
        _$CenterYouthcenterPaggingDtoImpl instance) =>
    <String, dynamic>{
      'totCount': instance.totCount,
      'pageNum': instance.pageNum,
      'pageSize': instance.pageSize,
    };

_$CenterYouthcenterItemDtoImpl _$$CenterYouthcenterItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CenterYouthcenterItemDtoImpl(
      cntrSn: json['cntrSn'] as String?,
      cntrNm: json['cntrNm'] as String?,
      cntrAddr: json['cntrAddr'] as String?,
      cntrDaddr: json['cntrDaddr'] as String?,
      cntrTelno: json['cntrTelno'] as String?,
      cntrUrlAddr: json['cntrUrlAddr'] as String?,
      stdgCtpvCd: json['stdgCtpvCd'] as String?,
      stdgCtpvCdNm: json['stdgCtpvCdNm'] as String?,
      stdgSggCd: json['stdgSggCd'] as String?,
      stdgSggCdNm: json['stdgSggCdNm'] as String?,
    );

Map<String, dynamic> _$$CenterYouthcenterItemDtoImplToJson(
        _$CenterYouthcenterItemDtoImpl instance) =>
    <String, dynamic>{
      'cntrSn': instance.cntrSn,
      'cntrNm': instance.cntrNm,
      'cntrAddr': instance.cntrAddr,
      'cntrDaddr': instance.cntrDaddr,
      'cntrTelno': instance.cntrTelno,
      'cntrUrlAddr': instance.cntrUrlAddr,
      'stdgCtpvCd': instance.stdgCtpvCd,
      'stdgCtpvCdNm': instance.stdgCtpvCdNm,
      'stdgSggCd': instance.stdgSggCd,
      'stdgSggCdNm': instance.stdgSggCdNm,
    };
