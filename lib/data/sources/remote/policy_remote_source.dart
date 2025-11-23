import 'package:dio/dio.dart';
import '../../models/policy_filter.dart';
import '../../models/policy_model.dart';

class PolicyRemoteSource {
  PolicyRemoteSource(this._dio, {String? apiKey})
      : _apiKey = apiKey ?? const String.fromEnvironment('YOUTH_API_KEY');

  final Dio _dio;
  final String _apiKey;

  Future<List<PolicyModel>> fetchPolicies({PolicyFilter filter = const PolicyFilter()}) async {
    if (_apiKey.isEmpty) {
      throw StateError('YOUTH_API_KEY is not provided');
    }

    final query = _buildQuery(filter);
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
    put('searchPolicyNm', filter.searchPolicyNm);
    put('searchPolicyType', filter.searchPolicyType);
    put('searchRgnSe', filter.searchRgnSe);
    put('instNo', filter.instNo);
    put('deptNo', filter.deptNo);

    return query;
  }
}
