// SOURCE: docs/청년센터API.json
// GENERATED_AT: 2025-12-05
// API_SN: 10001
// PURPOSE: External data preservation (contract level)

import 'package:freezed_annotation/freezed_annotation.dart';

part 'center_youthcenter_dto.freezed.dart';
part 'center_youthcenter_dto.g.dart';

@freezed
class CenterYouthcenterDto with _$CenterYouthcenterDto {
  const factory CenterYouthcenterDto({
    final int? resultCode,
    final String? resultMessage,
    final CenterYouthcenterResultDto? result,
  }) = _CenterYouthcenterDto;

  factory CenterYouthcenterDto.fromJson(Map<String, dynamic> json) =>
      _$CenterYouthcenterDtoFromJson(json);
}

@freezed
class CenterYouthcenterResultDto with _$CenterYouthcenterResultDto {
  const factory CenterYouthcenterResultDto({
    final CenterYouthcenterPaggingDto? pagging,
    final List<CenterYouthcenterItemDto>? youthPolicyList,
  }) = _CenterYouthcenterResultDto;

  factory CenterYouthcenterResultDto.fromJson(Map<String, dynamic> json) =>
      _$CenterYouthcenterResultDtoFromJson(json);
}

@freezed
class CenterYouthcenterPaggingDto with _$CenterYouthcenterPaggingDto {
  const factory CenterYouthcenterPaggingDto({
    final int? totCount,
    final int? pageNum,
    final int? pageSize,
  }) = _CenterYouthcenterPaggingDto;

  factory CenterYouthcenterPaggingDto.fromJson(Map<String, dynamic> json) =>
      _$CenterYouthcenterPaggingDtoFromJson(json);
}

@freezed
class CenterYouthcenterItemDto with _$CenterYouthcenterItemDto {
  const factory CenterYouthcenterItemDto({
    final String? cntrSn,
    final String? cntrNm,
    final String? cntrAddr,
    final String? cntrDaddr,
    final String? cntrTelno,
    final String? cntrUrlAddr,
    final String? stdgCtpvCd,
    final String? stdgCtpvCdNm,
    final String? stdgSggCd,
    final String? stdgSggCdNm,
  }) = _CenterYouthcenterItemDto;

  factory CenterYouthcenterItemDto.fromJson(Map<String, dynamic> json) =>
      _$CenterYouthcenterItemDtoFromJson(json);
}
