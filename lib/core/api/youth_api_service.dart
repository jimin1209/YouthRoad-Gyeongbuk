import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/retrofit.dart';

import '../../debug/debug_network_logger.dart';
import 'dto/policy_request_dto.dart';
import 'models/department_list_response.dart';
import 'models/institution_list_response.dart';
import 'models/policy_list_response.dart';

part 'youth_api_service.g.dart';

const String baseUrl = "https://api.youthroad.kr/v1";
const String apiKey = "yAlMhwGFZps7vHtbsjnbsL6Cpha6bHqaPDSScV6pgU0";

@RestApi(baseUrl: baseUrl)
abstract class YouthApiService {
  factory YouthApiService(Dio dio, {String baseUrl}) {
    if (kDebugMode) {
      DebugNetworkLogger.instance.attachTo(dio);
    }
    return _YouthApiService(dio, baseUrl: baseUrl);
  }

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
