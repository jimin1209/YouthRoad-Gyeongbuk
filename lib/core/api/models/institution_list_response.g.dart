// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'institution_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InstitutionListResponseImpl _$$InstitutionListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$InstitutionListResponseImpl(
      success: json['success'] as bool,
      msg: json['msg'] as String?,
      resultList: (json['resultList'] as List<dynamic>?)
          ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$InstitutionListResponseImplToJson(
        _$InstitutionListResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'resultList': instance.resultList,
    };
