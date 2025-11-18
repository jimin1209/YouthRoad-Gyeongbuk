import 'package:flutter_test/flutter_test.dart';
import 'package:youth_road_app/core/api/dto/policy_request_dto.dart';
import 'package:youth_road_app/core/api/models/department_list_response.dart';
import 'package:youth_road_app/core/api/models/institution_list_response.dart';
import 'package:youth_road_app/core/api/models/policy.dart' as remote;
import 'package:youth_road_app/core/api/models/policy_list_response.dart';
import 'package:youth_road_app/core/api/youth_api_service.dart';
import 'package:youth_road_app/features/policy/data/policy_repository.dart';

class _FakeYouthApiService implements YouthApiService {
  PolicyRequestDto? lastQuery;
  final List<remote.Policy> policies;

  _FakeYouthApiService(this.policies);

  @override
  Future<PolicyListResponse> fetchPolicies(PolicyRequestDto query) async {
    lastQuery = query;
    return PolicyListResponse(
      success: true,
      resultList: policies,
    );
  }

  @override
  Future<DepartmentListResponse> fetchDepartments(
    String apiKey,
    String? instNo,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<InstitutionListResponse> fetchInstitutions(
    String apiKey,
    String? srchInstNm,
  ) {
    throw UnimplementedError();
  }
}

void main() {
  group('PolicyRepository.getPolicies', () {
    test('sanitizes region and categories before querying', () async {
      final api = _FakeYouthApiService(const [
        remote.Policy(policyName: '테스트'),
      ]);
      final repository = PolicyRepository(api);

      await repository.getPolicies(
        region: 'ALL',
        status: '  APPLYING ',
        age: 0,
        keyword: '  청년 ',
        categories: [' EDUCATION ', '', 'HOUSING'],
        page: 0,
        size: 10,
      );

      final query = api.lastQuery?.toQuery();
      expect(query, isNotNull);
      expect(query!['searchRgnSe'], isNull);
      expect(query['searchPolicyType'], 'EDUCATION,HOUSING');
      expect(query['searchPolicyStatus'], 'APPLYING');
      expect(query['searchAge'], isNull);
      expect(query['searchKeyword'], '청년');
      expect(query['pageIndex'], '1');
      expect(query['pageSize'], '10');
    });

    test('drops empty categories entirely', () async {
      final api = _FakeYouthApiService(const []);
      final repository = PolicyRepository(api);

      await repository.getPolicies(
        categories: ['   '],
      );

      final query = api.lastQuery?.toQuery();
      expect(query, isNotNull);
      expect(query!['searchPolicyType'], isNull);
    });

    test('keeps positive age filters', () async {
      final api = _FakeYouthApiService(const []);
      final repository = PolicyRepository(api);

      await repository.getPolicies(
        age: 29,
      );

      final query = api.lastQuery?.toQuery();
      expect(query, isNotNull);
      expect(query!['searchAge'], '29');
    });
  });
}
