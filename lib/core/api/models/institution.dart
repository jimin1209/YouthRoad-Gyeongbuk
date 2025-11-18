import 'package:freezed_annotation/freezed_annotation.dart';

part 'institution.freezed.dart';
part 'institution.g.dart';

@freezed
class Institution with _$Institution {
  const factory Institution({
    String? id,
    String? name,
    String? description,
    String? region,
  }) = _Institution;

  factory Institution.fromJson(Map<String, dynamic> json) =>
      _$InstitutionFromJson(_normalizeInstitutionJson(json));
}

Map<String, dynamic> _normalizeInstitutionJson(Map<String, dynamic> json) {
  return {
    'id': json['id'] ?? json['institutionId'] ?? json['instNo'],
    'name': json['name'] ?? json['institutionName'] ?? json['instNm'],
    'description': json['description'] ?? json['instIntrcn'],
    'region': json['region'] ?? json['rgnSe'],
  }..removeWhere((_, value) => value == null);
}
