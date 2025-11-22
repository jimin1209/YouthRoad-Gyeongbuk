// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dept_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeptListResponseImpl _$$DeptListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$DeptListResponseImpl(
      success: json['success'] as bool,
      msg: json['msg'] as String,
      resultList: (json['resultList'] as List<dynamic>?)
              ?.map((e) => DeptItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$$DeptListResponseImplToJson(
        _$DeptListResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'resultList': instance.resultList,
    };

_$DeptItemImpl _$$DeptItemImplFromJson(Map<String, dynamic> json) =>
    _$DeptItemImpl(
      no: _stringFromJson(json['no']),
      instNm: _stringFromJson(json['instNm']),
      instNo: _stringFromJson(json['instNo']),
      deptNm: _stringFromJson(json['deptNm']),
      crtDt: _stringFromJson(json['crtDt']),
    );

Map<String, dynamic> _$$DeptItemImplToJson(_$DeptItemImpl instance) =>
    <String, dynamic>{
      'no': _stringToJson(instance.no),
      'instNm': _stringToJson(instance.instNm),
      'instNo': _stringToJson(instance.instNo),
      'deptNm': _stringToJson(instance.deptNm),
      'crtDt': _stringToJson(instance.crtDt),
    };
