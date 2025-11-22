// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PolicyListResponseImpl _$$PolicyListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PolicyListResponseImpl(
      success: json['success'] as bool,
      msg: json['msg'] as String,
      resultList: (json['resultList'] as List<dynamic>?)
              ?.map((e) => PolicyItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      paginationInfo: json['paginationInfo'] == null
          ? null
          : PaginationInfo.fromJson(
              json['paginationInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PolicyListResponseImplToJson(
        _$PolicyListResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'resultList': instance.resultList,
      'paginationInfo': instance.paginationInfo,
    };

_$PolicyItemImpl _$$PolicyItemImplFromJson(Map<String, dynamic> json) =>
    _$PolicyItemImpl(
      no: _stringFromJson(json['no']),
      policyYr: _stringFromJson(json['policyYr']),
      rgnSeNm: _stringFromJson(json['rgnSeNm']),
      policyTypeNm: _stringFromJson(json['policyTypeNm']),
      sprvsnInstNm: _stringFromJson(json['sprvsnInstNm']),
      operInstNm: _stringFromJson(json['operInstNm']),
      policyNm: _stringFromJson(json['policyNm']),
      policyBgngYmd: _stringFromJson(json['policyBgngYmd']),
      policyEndYmd: _stringFromJson(json['policyEndYmd']),
      policyScl: _stringFromJson(json['policyScl']),
      policyCn: _stringFromJson(json['policyCn']),
      policyEnq: _stringFromJson(json['policyEnq']),
      aplyYn: _stringFromJson(json['aplyYn']),
      aplyBgngDt: _stringFromJson(json['aplyBgngDt']),
      aplyEndDt: _stringFromJson(json['aplyEndDt']),
      aplyPsbltyYn: _stringFromJson(json['aplyPsbltyYn']),
      dtlLinkUrl: _stringFromJson(json['dtlLinkUrl']),
      dsplyYn: _stringFromJson(json['dsplyYn']),
      crtDt: _stringFromJson(json['crtDt']),
      updtDt: _stringFromJson(json['updtDt']),
    );

Map<String, dynamic> _$$PolicyItemImplToJson(_$PolicyItemImpl instance) =>
    <String, dynamic>{
      'no': _stringToJson(instance.no),
      'policyYr': _stringToJson(instance.policyYr),
      'rgnSeNm': _stringToJson(instance.rgnSeNm),
      'policyTypeNm': _stringToJson(instance.policyTypeNm),
      'sprvsnInstNm': _stringToJson(instance.sprvsnInstNm),
      'operInstNm': _stringToJson(instance.operInstNm),
      'policyNm': _stringToJson(instance.policyNm),
      'policyBgngYmd': _stringToJson(instance.policyBgngYmd),
      'policyEndYmd': _stringToJson(instance.policyEndYmd),
      'policyScl': _stringToJson(instance.policyScl),
      'policyCn': _stringToJson(instance.policyCn),
      'policyEnq': _stringToJson(instance.policyEnq),
      'aplyYn': _stringToJson(instance.aplyYn),
      'aplyBgngDt': _stringToJson(instance.aplyBgngDt),
      'aplyEndDt': _stringToJson(instance.aplyEndDt),
      'aplyPsbltyYn': _stringToJson(instance.aplyPsbltyYn),
      'dtlLinkUrl': _stringToJson(instance.dtlLinkUrl),
      'dsplyYn': _stringToJson(instance.dsplyYn),
      'crtDt': _stringToJson(instance.crtDt),
      'updtDt': _stringToJson(instance.updtDt),
    };

_$PaginationInfoImpl _$$PaginationInfoImplFromJson(Map<String, dynamic> json) =>
    _$PaginationInfoImpl(
      currentPageNo: _intFromJson(json['currentPageNo']),
      recordCountPerPage: _intFromJson(json['recordCountPerPage']),
      pageSize: _intFromJson(json['pageSize']),
      totalRecordCount: _intFromJson(json['totalRecordCount']),
      totalPageCount: _intFromJson(json['totalPageCount']),
      firstPageNo: _intFromJson(json['firstPageNo']),
      lastPageNo: _intFromJson(json['lastPageNo']),
      firstPageNoOnPageList: _intFromJson(json['firstPageNoOnPageList']),
      lastPageNoOnPageList: _intFromJson(json['lastPageNoOnPageList']),
    );

Map<String, dynamic> _$$PaginationInfoImplToJson(
        _$PaginationInfoImpl instance) =>
    <String, dynamic>{
      'currentPageNo': _intToJson(instance.currentPageNo),
      'recordCountPerPage': _intToJson(instance.recordCountPerPage),
      'pageSize': _intToJson(instance.pageSize),
      'totalRecordCount': _intToJson(instance.totalRecordCount),
      'totalPageCount': _intToJson(instance.totalPageCount),
      'firstPageNo': _intToJson(instance.firstPageNo),
      'lastPageNo': _intToJson(instance.lastPageNo),
      'firstPageNoOnPageList': _intToJson(instance.firstPageNoOnPageList),
      'lastPageNoOnPageList': _intToJson(instance.lastPageNoOnPageList),
    };
