// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DepartmentListResponseImpl _$$DepartmentListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$DepartmentListResponseImpl(
      success: json['success'] as bool,
      msg: json['msg'] as String?,
      resultList: (json['resultList'] as List<dynamic>?)
          ?.map((e) => Department.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DepartmentListResponseImplToJson(
        _$DepartmentListResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'resultList': instance.resultList,
    };
