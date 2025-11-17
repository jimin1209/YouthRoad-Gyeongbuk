import 'package:freezed_annotation/freezed_annotation.dart';

part 'policy.freezed.dart';
part 'policy.g.dart';

@freezed
class Policy with _$Policy {
  const factory Policy({
    String? id,
    String? policyName,
    String? policyType,
    String? region,
    String? institutionName,
    String? departmentName,
    String? startDate,
    String? endDate,
    String? applyUrl,
    String? description,
    String? displayYn,
  }) = _Policy;

  factory Policy.fromJson(Map<String, dynamic> json) => _$PolicyFromJson(json);
}
