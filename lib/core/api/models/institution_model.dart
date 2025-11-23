class InstitutionModel {
  const InstitutionModel({
    required this.id,
    required this.name,
    this.createdAt,
    this.departmentCount,
  });

  final String id;
  final String name;
  final String? createdAt;
  final int? departmentCount;

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    final idValue = json['no'];
    return InstitutionModel(
      id: idValue?.toString() ?? '',
      name: json['instNm'] as String? ?? '',
      createdAt: json['crtDt'] as String?,
      departmentCount: (json['deptCnt'] as num?)?.toInt(),
    );
  }
}
