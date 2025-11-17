import 'package:freezed_annotation/freezed_annotation.dart';

import 'policy.dart';

part 'policy_list_response.freezed.dart';
part 'policy_list_response.g.dart';

@freezed
class PolicyListResponse with _$PolicyListResponse {
  const factory PolicyListResponse({
    required bool success,
    String? msg,
    List<Policy>? resultList,
    Map<String, dynamic>? paginationInfo,
  }) = _PolicyListResponse;

  factory PolicyListResponse.fromJson(Map<String, dynamic> json) =>
      _$PolicyListResponseFromJson(json);
}
