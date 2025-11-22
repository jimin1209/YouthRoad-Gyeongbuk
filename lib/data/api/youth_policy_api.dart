import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/dept_models.dart';
import '../model/inst_models.dart';
import '../model/policy_models.dart';

part 'youth_policy_api.g.dart';

@RestApi()
abstract class YouthPolicyApi {
  factory YouthPolicyApi(Dio dio, {String baseUrl}) = _YouthPolicyApi;

  @GET('/openapi/policy/list.json')
  Future<PolicyListResponse> fetchPolicies({
    @Query('apiKey') required String apiKey,
    @Query('searchYear') String? searchYear,
    @Query('searchPolicyNm') String? searchPolicyNm,
    @Query('searchPolicyType') String? searchPolicyType,
    @Query('searchRgnSe') String? searchRgnSe,
    @Query('instNo') String? instNo,
    @Query('deptNo') String? deptNo,
    @Query('pageIndex') int pageIndex = 1,
    @Query('recordCount') int recordCount = 10,
    @Query('pageSize') int pageSize = 10,
    @Query('pagingYn') String? pagingYn,
    @Query('searchDsplyYn') String? searchDsplyYn,
    @Query('aplyPsbltyYn') String? aplyPsbltyYn,
  });

  @GET('/openapi/inst/list.json')
  Future<InstListResponse> fetchInstList({
    @Query('apiKey') required String apiKey,
    @Query('srchInstNm') String? srchInstNm,
  });

  @GET('/openapi/dept/list.json')
  Future<DeptListResponse> fetchDeptList({
    @Query('apiKey') required String apiKey,
    @Query('instNo') required String instNo,
  });
}
