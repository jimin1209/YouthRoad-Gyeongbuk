// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PolicyImpl _$$PolicyImplFromJson(Map<String, dynamic> json) => _$PolicyImpl(
      id: json['id'] as String?,
      policyName: json['policyName'] as String?,
      policyType: json['policyType'] as String?,
      region: json['region'] as String?,
      institutionName: json['institutionName'] as String?,
      departmentName: json['departmentName'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      applyUrl: json['applyUrl'] as String?,
      description: json['description'] as String?,
      displayYn: json['displayYn'] as String?,
    );

Map<String, dynamic> _$$PolicyImplToJson(_$PolicyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'policyName': instance.policyName,
      'policyType': instance.policyType,
      'region': instance.region,
      'institutionName': instance.institutionName,
      'departmentName': instance.departmentName,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'applyUrl': instance.applyUrl,
      'description': instance.description,
      'displayYn': instance.displayYn,
    };
