import 'package:freezed_annotation/freezed_annotation.dart';

part 'dept_models.freezed.dart';
part 'dept_models.g.dart';

String? _stringFromJson(Object? value) => value?.toString();
Object? _stringToJson(String? value) => value;
int? _intFromJson(Object? value) => value == null ? null : int.tryParse(value.toString());
int? _intToJson(int? value) => value;

@freezed
class DeptListResponse with _$DeptListResponse {
  const factory DeptListResponse({
    required bool success,
    required String msg,
    @JsonKey(defaultValue: []) required List<DeptItem> resultList,
  }) = _DeptListResponse;

  factory DeptListResponse.fromJson(Map<String, dynamic> json) =>
      _$DeptListResponseFromJson(json);
}

@freezed
class DeptItem with _$DeptItem {
  const factory DeptItem({
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? no,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? instNm,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? instNo,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? deptNm,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? crtDt,
  }) = _DeptItem;

  factory DeptItem.fromJson(Map<String, dynamic> json) => _$DeptItemFromJson(json);
}
