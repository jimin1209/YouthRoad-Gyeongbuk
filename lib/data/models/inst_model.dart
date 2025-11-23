import '../../domain/entities/institution_summary.dart';

class InstModel {
  const InstModel({
    required this.id,
    required this.name,
    this.tel,
    this.addr,
  });

  final String id;
  final String name;
  final String? tel;
  final String? addr;

  factory InstModel.fromJson(Map<String, dynamic> json) {
    final idValue = json['no'];
    return InstModel(
      id: idValue?.toString() ?? '',
      name: json['instNm'] as String? ?? '',
      tel: json['instTel'] as String?,
      addr: json['instAddr'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': id,
      'instNm': name,
      'instTel': tel,
      'instAddr': addr,
    };
  }

  InstitutionSummary toSummary() {
    return InstitutionSummary(instNo: id, name: name);
  }
}
