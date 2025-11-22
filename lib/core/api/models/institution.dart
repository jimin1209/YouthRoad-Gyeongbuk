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
      _$InstitutionFromJson(json);
}
