import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_config.dart';
import '../../core/network/dio_provider.dart';
import '../../core/network/error_handler.dart';
import '../../core/network/result.dart';
import '../../core/utils/formatters.dart';
import '../api/youth_policy_api.dart';
import '../model/dept_models.dart';
import '../model/inst_models.dart';
import '../model/policy_models.dart';

class YouthPolicyRepository {
  const YouthPolicyRepository({
    required YouthPolicyApi api,
    required YouthApiKeyProvider keyProvider,
  })  : _api = api,
        _keyProvider = keyProvider;

  final YouthPolicyApi _api;
  final YouthApiKeyProvider _keyProvider;

  Future<String> _apiKey(String? overrideKey) async {
    if (overrideKey != null && overrideKey.isNotEmpty) {
      return overrideKey;
    }
    final String key = await _keyProvider.getApiKey();
    return key;
  }

  Future<Result<PolicyListResponse>> fetchPolicies({
    String? apiKey,
    String? searchYear,
    String? searchPolicyNm,
    List<String>? searchPolicyType,
    List<String>? searchRgnSe,
    String? instNo,
    String? deptNo,
    int pageIndex = 1,
    int recordCount = 10,
    int pageSize = 10,
    String? pagingYn,
    String? searchDsplyYn,
    String? aplyPsbltyYn,
  }) async {
    final String key = await _apiKey(apiKey);
    final String? policyTypeParam = searchPolicyType == null ? null : joinListParam(searchPolicyType);
    final String? regionParam = searchRgnSe == null ? null : joinListParam(searchRgnSe);

    return safeApiCall(() {
      return _api.fetchPolicies(
        apiKey: key,
        searchYear: searchYear,
        searchPolicyNm: searchPolicyNm,
        searchPolicyType: policyTypeParam,
        searchRgnSe: regionParam,
        instNo: instNo,
        deptNo: deptNo,
        pageIndex: pageIndex,
        recordCount: recordCount,
        pageSize: pageSize,
        pagingYn: pagingYn,
        searchDsplyYn: searchDsplyYn,
        aplyPsbltyYn: aplyPsbltyYn,
      );
    });
  }

  Future<Result<InstListResponse>> fetchInstList({
    String? apiKey,
    String? srchInstNm,
  }) async {
    final String key = await _apiKey(apiKey);
    return safeApiCall(() {
      return _api.fetchInstList(apiKey: key, srchInstNm: srchInstNm);
    });
  }

  Future<Result<DeptListResponse>> fetchDeptList({
    String? apiKey,
    required String instNo,
  }) async {
    final String key = await _apiKey(apiKey);
    return safeApiCall(() {
      return _api.fetchDeptList(apiKey: key, instNo: instNo);
    });
  }
}

final youthPolicyApiProvider = Provider<YouthPolicyApi>((ref) {
  final dio = ref.watch(dioProvider);
  final config = ref.watch(youthApiConfigProvider);
  return YouthPolicyApi(dio, baseUrl: config.baseUrl);
});

final youthPolicyRepositoryProvider = Provider<YouthPolicyRepository>((ref) {
  return YouthPolicyRepository(
    api: ref.watch(youthPolicyApiProvider),
    keyProvider: ref.watch(youthApiKeyProvider),
  );
});
