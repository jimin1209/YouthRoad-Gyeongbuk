class DepartmentModel {
  const DepartmentModel({
    required this.id,
    required this.instName,
    required this.deptName,
    this.createdAt,
  });

  final String id;
  final String instName;
  final String deptName;
  final String? createdAt;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    final idValue = json['no'];
    return DepartmentModel(
      id: idValue?.toString() ?? '',
      instName: json['instNm'] as String? ?? '',
      deptName: json['deptNm'] as String? ?? '',
      createdAt: json['crtDt'] as String?,
    );
  }
}
