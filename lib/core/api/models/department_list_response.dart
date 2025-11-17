import 'package:freezed_annotation/freezed_annotation.dart';

import 'department.dart';

part 'department_list_response.freezed.dart';
part 'department_list_response.g.dart';

@freezed
class DepartmentListResponse with _$DepartmentListResponse {
  const factory DepartmentListResponse({
    required bool success,
    String? msg,
    List<Department>? resultList,
  }) = _DepartmentListResponse;

  factory DepartmentListResponse.fromJson(Map<String, dynamic> json) =>
      _$DepartmentListResponseFromJson(json);
}
