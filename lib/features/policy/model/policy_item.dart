import 'package:freezed_annotation/freezed_annotation.dart';

part 'policy_item.freezed.dart';
part 'policy_item.g.dart';

String? _string(Object? value) => value?.toString();

@freezed
class PolicyItem with _$PolicyItem {
  const factory PolicyItem({
    @JsonKey(name: 'no', fromJson: _string) String? id,
    @JsonKey(name: 'policyNm') String? title,
    @JsonKey(name: 'policyCn') String? description,
    @JsonKey(name: 'instNm') String? instNm,
    @JsonKey(name: 'deptNm') String? deptNm,
    @JsonKey(name: 'policyTypeNm') String? policyType,
    @JsonKey(name: 'rgnSeNm') String? region,
    @JsonKey(name: 'policyBgngYmd') String? startDate,
    @JsonKey(name: 'policyEndYmd') String? endDate,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'aplyPsbltyYn') String? applyAbleYn,
    @JsonKey(name: 'instTel') String? instTel,
  }) = _PolicyItem;

  factory PolicyItem.fromJson(Map<String, dynamic> json) => _$PolicyItemFromJson(json);
}

@freezed
class PolicyListResponse with _$PolicyListResponse {
  const factory PolicyListResponse({
    @JsonKey(defaultValue: []) required List<PolicyItem> items,
    @JsonKey(name: 'resultList', defaultValue: []) List<PolicyItem>? resultList,
    @Default(0) int totalCount,
    @Default(1) int pageIndex,
    @Default(10) int pageSize,
  }) = _PolicyListResponse;

  factory PolicyListResponse.fromJson(Map<String, dynamic> json) =>
      _$PolicyListResponseFromJson(json);
}
