import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../models/policy_filter.dart';
import '../../models/policy_model.dart';
import '../../../core/constants/env.dart';

class PolicyRemoteSource {
  PolicyRemoteSource(this._dio, {String? apiKey})
      : _apiKey = apiKey ?? Env.youthApiKey;

  final Dio _dio;
  final String _apiKey;

  Future<List<PolicyModel>> fetchPolicies({PolicyFilter filter = const PolicyFilter()}) async {
    if (kDebugMode) {
      debugPrint('[PolicyRemoteSource] fetchPolicies called. filter: $filter');
    }

    if (_apiKey.isEmpty && !kDebugMode) {
      throw StateError('YOUTH_API_KEY is not provided');
    }

    final effectiveKey = _apiKey.isEmpty && kDebugMode ? 'DEBUG-PLACEHOLDER-KEY' : _apiKey;

    if (kDebugMode && _apiKey.isEmpty) {
      debugPrint(
        '[PolicyRemoteSource] YOUTH_API_KEY is empty. '
        'Using debug placeholder key just to send HTTP request.',
      );
    }

    final query = _buildQuery(filter);
    query['apiKey'] = effectiveKey;

    if (kDebugMode) {
      debugPrint(
        '[PolicyRemoteSource] fetchPolicies -> URL=/openapi/policy/list.json '
        'query=$query',
      );
    }
    final response = await _dio.get(
      'https://gbyouth.co.kr/openapi/policy/list.json',
      queryParameters: query,
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw StateError('Invalid policy list response');
    }

    final resultList = data['resultList'];
    if (resultList is! List) {
      throw StateError('Missing resultList in response');
    }

    return resultList
        .map((item) => PolicyModel.fromJson((item as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<PolicyModel> fetchPolicyById(String id) async {
    final list = await fetchPolicies(
      filter: const PolicyFilter(
        pagingYn: 'N',
        searchDsplyYn: 'all',
        recordCount: 2000,
      ),
    );
    final match = list.firstWhere(
      (policy) => policy.id == id,
      orElse: () => throw StateError('Policy not found for id: $id'),
    );
    return match;
  }

  Future<List<PolicyModel>> fetchSimilar(String id) async {
    final base = await fetchPolicyById(id);
    final filter = PolicyFilter(
      searchRgnSe: base.regionName,
      searchPolicyType: base.typeName,
      pageIndex: 1,
      recordCount: 10,
    );
    final list = await fetchPolicies(filter: filter);
    return list.where((item) => item.id != id).toList();
  }

  Map<String, dynamic> _buildQuery(PolicyFilter filter) {
    final query = <String, dynamic>{
      'apiKey': _apiKey,
      'pageIndex': filter.pageIndex ?? 1,
      'recordCount': filter.recordCount ?? filter.pageSize ?? 10,
      'pageSize': filter.pageSize,
      'pagingYn': filter.pagingYn ?? 'Y',
      'searchDsplyYn': filter.searchDsplyYn ?? 'Y',
    };

    void put(String key, dynamic value) {
      if (value != null && value.toString().isNotEmpty) {
        query[key] = value;
      }
    }

    put('searchYear', filter.searchYear);
    put('searchPolicyNm', filter.searchPolicyNm ?? filter.searchText);
    put('searchPolicyType', filter.searchPolicyType ?? filter.category);
    put('searchRgnSe', filter.searchRgnSe);
    put('instNo', filter.instNo);
    put('deptNo', filter.deptNo);
    if (filter.availableOnly == true) {
      put('aplyPsbltyYn', 'Y');
    }
    if (filter.startDate != null) {
      put('policyBgngYmd', _formatDate(filter.startDate!));
    }
    if (filter.endDate != null) {
      put('policyEndYmd', _formatDate(filter.endDate!));
    }

    return query;
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}'
        '${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
