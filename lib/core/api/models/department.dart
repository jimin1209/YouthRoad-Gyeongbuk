import 'package:freezed_annotation/freezed_annotation.dart';

part 'department.freezed.dart';
part 'department.g.dart';

@freezed
class Department with _$Department {
  const factory Department({
    String? id,
    String? name,
    String? institutionId,
    String? description,
  }) = _Department;

  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(_normalizeDepartmentJson(json));
}

Map<String, dynamic> _normalizeDepartmentJson(Map<String, dynamic> json) {
  return {
    'id': json['id'] ?? json['deptId'] ?? json['deptNo'],
    'name': json['name'] ?? json['deptName'] ?? json['deptNm'],
    'institutionId': json['institutionId'] ?? json['instNo'],
    'description': json['description'] ?? json['deptIntrcn'],
  }..removeWhere((_, value) => value == null);
}
