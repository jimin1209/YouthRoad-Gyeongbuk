// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PolicyListResponseImpl _$$PolicyListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PolicyListResponseImpl(
      success: json['success'] as bool,
      msg: json['msg'] as String?,
      resultList: (json['resultList'] as List<dynamic>?)
          ?.map((e) => Policy.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginationInfo: json['paginationInfo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PolicyListResponseImplToJson(
        _$PolicyListResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'resultList': instance.resultList,
      'paginationInfo': instance.paginationInfo,
    };
