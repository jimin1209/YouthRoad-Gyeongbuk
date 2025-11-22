import 'package:freezed_annotation/freezed_annotation.dart';

part 'inst_models.freezed.dart';
part 'inst_models.g.dart';

String? _stringFromJson(Object? value) => value?.toString();
Object? _stringToJson(String? value) => value;
int? _intFromJson(Object? value) => value == null ? null : int.tryParse(value.toString());
int? _intToJson(int? value) => value;

@freezed
class InstListResponse with _$InstListResponse {
  const factory InstListResponse({
    required bool success,
    required String msg,
    @JsonKey(defaultValue: []) required List<InstItem> resultList,
  }) = _InstListResponse;

  factory InstListResponse.fromJson(Map<String, dynamic> json) =>
      _$InstListResponseFromJson(json);
}

@freezed
class InstItem with _$InstItem {
  const factory InstItem({
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? no,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? instNm,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? instKindNm,
    @JsonKey(fromJson: _stringFromJson, toJson: _stringToJson) String? crtDt,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? deptCnt,
  }) = _InstItem;

  factory InstItem.fromJson(Map<String, dynamic> json) => _$InstItemFromJson(json);
}
