import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youth_road_app/core/api/dto/policy_request_dto.dart';
import 'package:youth_road_app/core/api/youth_api_service.dart';
import 'package:youth_road_app/core/network/network_error.dart';

const String _apiKey = String.fromEnvironment('YOUTHROAD_API_KEY');

void main() {
  group('YouthRoad live API', () {
    if (_apiKey.isEmpty) {
      test(
        'skipped because YOUTHROAD_API_KEY is not provided',
        () {},
        skip: 'Set --dart-define=YOUTHROAD_API_KEY to run live API checks',
      );
      return;
    }

    late YouthApiService api;
    late int? lastStatus;

    setUp(() {
      lastStatus = null;
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onResponse: (response, handler) {
            lastStatus = response.statusCode;
            handler.next(response);
          },
        ),
      );
      api = YouthApiService(dio);
    });

    test('policies endpoint returns data', () async {
      final response = await api.fetchPolicies(
        PolicyRequestDto(
          apiKey: _apiKey,
          pageIndex: 1,
          pageSize: 5,
        ),
      );

      expect(lastStatus, equals(200));
      expect(response.success, isTrue);
      expect(response.resultList, isNotNull);
    });

    test('invalid endpoint surfaces as server error', () async {
      final failingApi = YouthApiService(
        Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
            baseUrl: '$baseUrl/invalid',
          ),
        ),
        baseUrl: '$baseUrl/invalid',
      );

      expect(
        () => failingApi.fetchPolicies(
          PolicyRequestDto(apiKey: _apiKey, pageIndex: 1, pageSize: 1),
        ),
        throwsA(isA<DioException>().having(
          (err) => YouthRoadErrorMapper.fromDio(err).category,
          'category',
          YouthRoadErrorCategory.server,
        )),
      );
    });

    test('connect timeout maps to network category', () async {
      final slowApi = YouthApiService(
        Dio(
          BaseOptions(
            baseUrl: 'https://10.255.255.1',
            connectTimeout: const Duration(milliseconds: 500),
            receiveTimeout: const Duration(seconds: 2),
          ),
        ),
        baseUrl: 'https://10.255.255.1',
      );

      expect(
        () => slowApi.fetchPolicies(
          PolicyRequestDto(apiKey: _apiKey, pageIndex: 1, pageSize: 1),
        ),
        throwsA(isA<DioException>().having(
          (err) => YouthRoadErrorMapper.fromDio(err).category,
          'category',
          YouthRoadErrorCategory.network,
        )),
      );
    });

    test('institutions endpoint returns data and departments resolve', () async {
      final institutions = await api.fetchInstitutions(_apiKey, null);

      expect(lastStatus, equals(200));
      expect(institutions.success, isTrue);
      expect(institutions.resultList, isNotNull);
      expect(institutions.resultList, isNotEmpty);

      final firstInstitution = institutions.resultList!.first;
      expect(firstInstitution.id, isNotEmpty);

      lastStatus = null;
      final departments =
          await api.fetchDepartments(_apiKey, firstInstitution.id);

      expect(lastStatus, equals(200));
      expect(departments.success, isTrue);
      expect(departments.resultList, isNotNull);
    });
  });
}
