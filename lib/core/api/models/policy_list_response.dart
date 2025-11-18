import 'policy.dart';
import 'pagination_info.dart';

class PolicyListResponse {
  const PolicyListResponse({
    required this.success,
    this.msg,
    this.resultList,
    this.paginationInfo,
  });

  final bool success;
  final String? msg;
  final List<Policy>? resultList;
  final PaginationInfo? paginationInfo;

  factory PolicyListResponse.fromJson(Map<String, dynamic> json) {
    return PolicyListResponse(
      success: _asBool(json['success']),
      msg: json['msg'] as String?,
      resultList: (json['resultList'] as List<dynamic>?)
          ?.map((item) => Policy.fromJson(item as Map<String, dynamic>))
          .toList(),
      paginationInfo: json['paginationInfo'] == null
          ? null
          : PaginationInfo.fromJson(
              json['paginationInfo'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'msg': msg,
      'resultList': resultList?.map((policy) => policy.toJson()).toList(),
      'paginationInfo': paginationInfo?.toJson(),
    };
  }
}

bool _asBool(dynamic value) {
  if (value == null) {
    return false;
  }
  if (value is bool) {
    return value;
  }
  final lowered = value.toString().toLowerCase();
  return lowered == 'true' || lowered == 'y';
}
