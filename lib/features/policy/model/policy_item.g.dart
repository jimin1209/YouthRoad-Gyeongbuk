// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PolicyItemImpl _$$PolicyItemImplFromJson(Map<String, dynamic> json) =>
    _$PolicyItemImpl(
      id: _string(json['no']),
      title: json['policyNm'] as String?,
      description: json['policyCn'] as String?,
      instNm: json['instNm'] as String?,
      deptNm: json['deptNm'] as String?,
      policyType: json['policyTypeNm'] as String?,
      region: json['rgnSeNm'] as String?,
      startDate: json['policyBgngYmd'] as String?,
      endDate: json['policyEndYmd'] as String?,
      url: json['url'] as String?,
      applyAbleYn: json['aplyPsbltyYn'] as String?,
      instTel: json['instTel'] as String?,
    );

Map<String, dynamic> _$$PolicyItemImplToJson(_$PolicyItemImpl instance) =>
    <String, dynamic>{
      'no': instance.id,
      'policyNm': instance.title,
      'policyCn': instance.description,
      'instNm': instance.instNm,
      'deptNm': instance.deptNm,
      'policyTypeNm': instance.policyType,
      'rgnSeNm': instance.region,
      'policyBgngYmd': instance.startDate,
      'policyEndYmd': instance.endDate,
      'url': instance.url,
      'aplyPsbltyYn': instance.applyAbleYn,
      'instTel': instance.instTel,
    };

_$PolicyListResponseImpl _$$PolicyListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PolicyListResponseImpl(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => PolicyItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      resultList: (json['resultList'] as List<dynamic>?)
              ?.map((e) => PolicyItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      pageIndex: (json['pageIndex'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
    );

Map<String, dynamic> _$$PolicyListResponseImplToJson(
        _$PolicyListResponseImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'resultList': instance.resultList,
      'totalCount': instance.totalCount,
      'pageIndex': instance.pageIndex,
      'pageSize': instance.pageSize,
    };
