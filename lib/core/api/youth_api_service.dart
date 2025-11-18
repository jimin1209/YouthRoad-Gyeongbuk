import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'dto/policy_request_dto.dart';
import 'models/department_list_response.dart';
import 'models/institution_list_response.dart';
import 'models/policy_list_response.dart';
import '../network/api_interceptor.dart';

part 'youth_api_service.g.dart';

const String baseUrl = "https://api.youthroad.kr/v1";
const String apiKey = "yAlMhwGFZps7vHtbsjnbsL6Cpha6bHqaPDSScV6pgU0";

YouthApiService createYouthApiService({
  Dio? dio,
  TokenProvider? tokenProvider,
}) {
  final client = dio ??
      Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
  final hasInterceptor =
      client.interceptors.whereType<ApiInterceptor>().isNotEmpty;
  if (!hasInterceptor) {
    client.interceptors.add(ApiInterceptor(dio: client, tokenProvider: tokenProvider));
  }
  return YouthApiService(client);
}

@RestApi(baseUrl: baseUrl)
abstract class YouthApiService {
  factory YouthApiService(Dio dio, {String baseUrl}) = _YouthApiService;

  @GET("/policies")
  Future<PolicyListResponse> fetchPolicies(@Queries() PolicyRequestDto query);

  @GET("/institutions")
  Future<InstitutionListResponse> fetchInstitutions(
    @Query("apiKey") String apiKey,
    @Query("srchInstNm") String? srchInstNm,
  );

  @GET("/departments")
  Future<DepartmentListResponse> fetchDepartments(
    @Query("apiKey") String apiKey,
    @Query("instNo") String? instNo,
  );
}
