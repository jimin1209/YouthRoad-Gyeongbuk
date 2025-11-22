import 'package:freezed_annotation/freezed_annotation.dart';

import 'institution.dart';

part 'institution_list_response.freezed.dart';
part 'institution_list_response.g.dart';

@freezed
class InstitutionListResponse with _$InstitutionListResponse {
  const factory InstitutionListResponse({
    required bool success,
    String? msg,
    List<Institution>? resultList,
  }) = _InstitutionListResponse;

  factory InstitutionListResponse.fromJson(Map<String, dynamic> json) =>
      _$InstitutionListResponseFromJson(json);
}
