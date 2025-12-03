import '../../domain/entities/department.dart';

class DepartmentModel {
  const DepartmentModel({
    required this.id,
    required this.instNo,
    required this.name,
    this.tel,
  });

  final String id;
  final String instNo;
  final String name;
  final String? tel;

  factory DepartmentModel.fromJson(
    Map<String, dynamic> json, {
    required String instNo,
  }) {
    final idValue = json['no'];
    return DepartmentModel(
      id: idValue?.toString() ?? '',
      instNo: instNo,
      name: json['deptNm']?.toString() ?? '',
      tel: json['deptTel'] as String?,
    );
  }

  Department toDomain() {
    return Department(
      id: id,
      instNo: instNo,
      name: name,
      tel: tel,
    );
  }
}
