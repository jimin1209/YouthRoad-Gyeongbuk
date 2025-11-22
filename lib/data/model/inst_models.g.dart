// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inst_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InstListResponseImpl _$$InstListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$InstListResponseImpl(
      success: json['success'] as bool,
      msg: json['msg'] as String,
      resultList: (json['resultList'] as List<dynamic>?)
              ?.map((e) => InstItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$$InstListResponseImplToJson(
        _$InstListResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'resultList': instance.resultList,
    };

_$InstItemImpl _$$InstItemImplFromJson(Map<String, dynamic> json) =>
    _$InstItemImpl(
      no: _stringFromJson(json['no']),
      instNm: _stringFromJson(json['instNm']),
      instKindNm: _stringFromJson(json['instKindNm']),
      crtDt: _stringFromJson(json['crtDt']),
      deptCnt: _intFromJson(json['deptCnt']),
    );

Map<String, dynamic> _$$InstItemImplToJson(_$InstItemImpl instance) =>
    <String, dynamic>{
      'no': _stringToJson(instance.no),
      'instNm': _stringToJson(instance.instNm),
      'instKindNm': _stringToJson(instance.instKindNm),
      'crtDt': _stringToJson(instance.crtDt),
      'deptCnt': _intToJson(instance.deptCnt),
    };
