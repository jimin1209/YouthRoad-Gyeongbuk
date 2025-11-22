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
      _$DepartmentFromJson(json);
}
