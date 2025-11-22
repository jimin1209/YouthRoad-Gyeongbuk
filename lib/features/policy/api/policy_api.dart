import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/policy_item.dart';

part 'policy_api.g.dart';

@RestApi()
abstract class PolicyApi {
  factory PolicyApi(Dio dio, {String baseUrl}) = _PolicyApi;

  @GET('/openapi/policy/list.json')
  Future<PolicyListResponse> fetchPolicies({
    @Query('apiKey') required String apiKey,
    @Query('searchRgnSe') String? searchRgnSe,
    @Query('searchPolicyType') String? searchPolicyType,
    @Query('searchKeyword') String? searchKeyword,
    @Query('pageIndex') int pageIndex = 1,
    @Query('pageSize') int pageSize = 10,
    @Query('yyyy') String? yyyy,
    @Query('applyAbleFilter') String? applyAbleFilter,
  });
}
