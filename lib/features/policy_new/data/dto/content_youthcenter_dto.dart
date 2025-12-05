// SOURCE: docs/청년콘텐츠API.json
// GENERATED_AT: 2025-12-05
// API_SN: 20
// PURPOSE: External data preservation (contract level)

import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_youthcenter_dto.freezed.dart';
part 'content_youthcenter_dto.g.dart';

@freezed
class ContentYouthcenterDto with _$ContentYouthcenterDto {
  const factory ContentYouthcenterDto({
    final int? resultCode,
    final String? resultMessage,
    final ContentYouthcenterResultDto? result,
  }) = _ContentYouthcenterDto;

  factory ContentYouthcenterDto.fromJson(Map<String, dynamic> json) =>
      _$ContentYouthcenterDtoFromJson(json);
}

@freezed
class ContentYouthcenterResultDto with _$ContentYouthcenterResultDto {
  const factory ContentYouthcenterResultDto({
    final ContentYouthcenterPaggingDto? pagging,
    final List<ContentYouthcenterItemDto>? youthPolicyList,
  }) = _ContentYouthcenterResultDto;

  factory ContentYouthcenterResultDto.fromJson(Map<String, dynamic> json) =>
      _$ContentYouthcenterResultDtoFromJson(json);
}

@freezed
class ContentYouthcenterPaggingDto with _$ContentYouthcenterPaggingDto {
  const factory ContentYouthcenterPaggingDto({
    final int? totCount,
    final int? pageNum,
    final int? pageSize,
  }) = _ContentYouthcenterPaggingDto;

  factory ContentYouthcenterPaggingDto.fromJson(Map<String, dynamic> json) =>
      _$ContentYouthcenterPaggingDtoFromJson(json);
}

@freezed
class ContentYouthcenterItemDto with _$ContentYouthcenterItemDto {
  const factory ContentYouthcenterItemDto({
    final String? bbsSn,
    final String? pstSn,
    final String? pstSeSn,
    final String? pstSeNm,
    final String? pstTtl,
    final String? pstWholCn,
    final String? pstUrlAddr,
    final String? atchFile,
    final String? pstInqCnt,
    final String? frstRegDt,
    final String? frstRgtrNm,
    final String? lastMdfcnDt,
    final String? lastMdfrNm,
  }) = _ContentYouthcenterItemDto;

  factory ContentYouthcenterItemDto.fromJson(Map<String, dynamic> json) =>
      _$ContentYouthcenterItemDtoFromJson(json);
}
