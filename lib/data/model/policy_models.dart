import 'package:freezed_annotation/freezed_annotation.dart';

part 'policy_models.freezed.dart';
part 'policy_models.g.dart';

String? _stringFromJson(Object? value) => value?.toString();
Object? _stringToJson(String? value) => value;

int? _intFromJson(Object? value) {
  if (value == null) return null;
  return int.tryParse(value.toString());
}

@freezed
class PolicyListResponse with _$PolicyListResponse {
  const factory PolicyListResponse({
    required bool success,
    required String msg,
    @JsonKey(defaultValue: []) required List<PolicyItem> resultList,
    PaginationInfo? paginationInfo,
  }) = _PolicyListResponse;

  factory PolicyListResponse.fromJson(Map<String, dynamic> json) =>
      _$PolicyListResponseFromJson(json);
}

@freezed
class PolicyItem with _$PolicyItem {
  const factory PolicyItem({
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? no,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? policyYr,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? rgnSeNm,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? policyTypeNm,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? sprvsnInstNm,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? operInstNm,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? policyNm,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? policyBgngYmd,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? policyEndYmd,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? policyScl,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? policyCn,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? policyEnq,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? aplyYn,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? aplyBgngDt,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? aplyEndDt,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? aplyPsbltyYn,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? dtlLinkUrl,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? dsplyYn,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? crtDt,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? updtDt,
  }) = _PolicyItem;

  factory PolicyItem.fromJson(Map<String, dynamic> json) =>
      _$PolicyItemFromJson(json);
}

@freezed
class PaginationInfo with _$PaginationInfo {
  const factory PaginationInfo({
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? currentPageNo,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? recordCountPerPage,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? pageSize,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? totalRecordCount,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? totalPageCount,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? firstPageNo,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? lastPageNo,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? firstPageNoOnPageList,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? lastPageNoOnPageList,
  }) = _PaginationInfo;

  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);
}

int? _intToJson(int? value) => value;
