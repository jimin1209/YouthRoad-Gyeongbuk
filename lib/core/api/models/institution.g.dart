// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'institution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InstitutionImpl _$$InstitutionImplFromJson(Map<String, dynamic> json) =>
    _$InstitutionImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      region: json['region'] as String?,
    );

Map<String, dynamic> _$$InstitutionImplToJson(_$InstitutionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'region': instance.region,
    };
