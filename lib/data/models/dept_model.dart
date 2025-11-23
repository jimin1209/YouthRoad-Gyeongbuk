class DeptModel {
  const DeptModel({
    required this.id,
    required this.instNo,
    required this.name,
    this.tel,
  });

  final String id;
  final String instNo;
  final String name;
  final String? tel;

  factory DeptModel.fromJson(Map<String, dynamic> json, {required String instNo}) {
    final idValue = json['no'];
    return DeptModel(
      id: idValue?.toString() ?? '',
      instNo: instNo,
      name: json['deptNm'] as String? ?? '',
      tel: json['deptTel'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': id,
      'instNo': instNo,
      'deptNm': name,
      'deptTel': tel,
    };
  }
}
