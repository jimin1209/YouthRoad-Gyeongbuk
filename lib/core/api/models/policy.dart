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

  factory Policy.fromJson(Map<String, dynamic> json) =>
      _$PolicyFromJson(_normalizePolicyJson(json));
}

Map<String, dynamic> _normalizePolicyJson(Map<String, dynamic> json) {
  return {
    'id': json['id'] ?? json['policyId'] ?? json['policyNo'],
    'policyName': json['policyName'] ?? json['policyNm'] ?? json['title'],
    'policyType': json['policyType'] ?? json['policyTypeCd'],
    'region': json['region'] ?? json['searchRgnSe'] ?? json['policyRgnSe'],
    'institutionName':
        json['institutionName'] ?? json['instNm'] ?? json['instName'],
    'departmentName': json['departmentName'] ?? json['deptNm'],
    'startDate': json['startDate'] ?? json['policyStartDate'],
    'endDate': json['endDate'] ?? json['policyEndDate'],
    'applyUrl': json['applyUrl'] ?? json['applicationUrl'],
    'description': json['description'] ?? json['policyContent'],
    'displayYn': json['displayYn'] ?? json['policyPblancEndAtYn'],
  }..removeWhere((_, value) => value == null);
}
