import 'package:dio/dio.dart';

import '../../domain/values/policy_failure.dart';
import '../models/policy_model.dart';

class PolicyRemoteSource {
  PolicyRemoteSource(
    this._dio, {
    required this.apiKey,
    required this.baseUrl,
  });

  final Dio _dio;
  final String apiKey;
  final String baseUrl;

  Future<List<PolicyModel>> fetchPoliciesWithParams(
    Map<String, dynamic> queryParameters,
  ) async {
    final params = _withDefaults(queryParameters);
    try {
      final res = await _dio.get(
        '$baseUrl/policy/list.json',
        queryParameters: params,
      );

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw const ServerFailure('정책 목록 응답이 올바르지 않습니다');
      }

      final list = data['resultList'];
      if (list is! List) {
        throw const ServerFailure('정책 목록을 찾을 수 없습니다');
      }

      return list
          .map((e) => PolicyModel.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    } on DioError {
      throw const NetworkFailure();
    } catch (e) {
      if (e is PolicyFailure) rethrow;
      throw const UnknownFailure();
    }
  }

  Future<PolicyModel> fetchPolicyDetail(String id) async {
    const pageSize = 100;
    const maxPages = 50;

    for (var pageIndex = 1; pageIndex <= maxPages; pageIndex++) {
      final list = await fetchPoliciesWithParams({
        'pagingYn': 'Y',
        'recordCount': pageSize,
        'pageSize': pageSize,
        'pageIndex': pageIndex,
      });

      for (final policy in list) {
        if (policy.id == id) return policy;
      }

      if (list.length < pageSize) break;
    }

    throw const ServerFailure('정책 상세 정보를 찾을 수 없습니다');
  }

  Future<List<PolicyModel>> fetchPoliciesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    try {
      final futures = ids.map(fetchPolicyDetail);
      return await Future.wait(futures);
    } on PolicyFailure {
      rethrow;
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Map<String, dynamic> _withDefaults(Map<String, dynamic> params) {
    final query = <String, dynamic>{
      'pageIndex': params['pageIndex'] ?? params['page'] ?? 1,
      'pageSize': params['pageSize'] ?? params['size'] ?? 20,
      'recordCount': params['recordCount'] ?? params['pageSize'] ?? 20,
      'pagingYn': params['pagingYn'] ?? 'Y',
      'searchDsplyYn': params['searchDsplyYn'] ?? 'all',
    }..addAll(params);

    if (apiKey.isNotEmpty) {
      query['apiKey'] = apiKey;
    }

    return query;
  }
}
