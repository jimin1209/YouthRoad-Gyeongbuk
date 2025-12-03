import '../../domain/entities/institution.dart';

class InstitutionModel {
  const InstitutionModel({
    required this.id,
    required this.name,
    this.tel,
    this.address,
  });

  final String id;
  final String name;
  final String? tel;
  final String? address;

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    final idValue = json['no'];
    return InstitutionModel(
      id: idValue?.toString() ?? '',
      name: json['instNm']?.toString() ?? '',
      tel: json['instTel'] as String?,
      address: json['instAddr'] as String?,
    );
  }

  Institution toDomain() {
    return Institution(
      id: id,
      name: name,
      tel: tel,
      address: address,
    );
  }
}
