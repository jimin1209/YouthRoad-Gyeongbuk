import 'package:dio/dio.dart';

import '../../domain/values/policy_failure.dart';
import '../models/policy_model.dart';

class PolicyRemoteSource {
  final Dio _dio;

  PolicyRemoteSource(this._dio);

  List<dynamic> _extractPolicyList(dynamic rawData) {
    final queue = <dynamic>[rawData];

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      if (current is List) return current;

      if (current is Map<String, dynamic>) {
        final candidates = [
          current['policies'],
          current['data'],
          current['items'],
          current['content'],
          current['result'],
          current['list'],
        ];

        for (final candidate in candidates) {
          if (candidate == null) continue;
          if (candidate is List) return candidate;
          if (candidate is Map<String, dynamic>) queue.add(candidate);
        }

        // 알려지지 않은 래퍼 키를 가진 경우에도 맵의 모든 값들을 탐색해 리스트를 찾는다.
        for (final value in current.values) {
          if (value is List) return value;
          if (value is Map<String, dynamic>) queue.add(value);
        }
      }
    }

    return const [];
  }

  /// 기존 job01용 단순 페이지 조회 (하위 호환 유지)
  Future<List<PolicyModel>> fetchPolicies(int page, int pageSize) async {
    final params = <String, dynamic>{
      'page': page,
      'size': pageSize,
    };
    return fetchPoliciesWithParams(params);
  }

  /// job03에서 추가: QueryParameter 기반 페이지 조회
  Future<List<PolicyModel>> fetchPoliciesWithParams(
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final res = await _dio.get(
        '/policies',
        queryParameters: queryParameters,
      );

      final data = _extractPolicyList(res.data);

      return data
          .whereType<Map<String, dynamic>>()
          .map(PolicyModel.fromJson)
          .toList();
    } on DioError {
      throw const NetworkFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<PolicyModel> fetchPolicyDetail(String id) async {
    try {
      final res = await _dio.get('/policies/$id');
      return PolicyModel.fromJson(res.data as Map<String, dynamic>);
    } on DioError {
      throw const NetworkFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}
