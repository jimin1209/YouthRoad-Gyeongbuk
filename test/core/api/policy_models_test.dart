import 'package:flutter_test/flutter_test.dart';
import 'package:youth_road_app/core/api/models/department.dart';
import 'package:youth_road_app/core/api/models/institution.dart';
import 'package:youth_road_app/core/api/models/policy.dart';
import 'package:youth_road_app/core/api/models/policy_list_response.dart';

void main() {
  group('Policy normalization', () {
    test('maps YouthRoad alias fields safely', () {
      final policy = Policy.fromJson({
        'policyNo': 'P-001',
        'title': '청년 주거 지원',
        'policyTypeCd': 'HOUSING',
        'policyRgnSe': '11',
        'instNm': '서울시',
        'deptNm': '청년정책과',
        'policyStartDate': '2024-01-01',
        'policyEndDate': '2024-12-31',
        'applicationUrl': 'https://apply',
        'policyContent': '설명',
        'policyPblancEndAtYn': 'N',
      });

      expect(policy.id, 'P-001');
      expect(policy.policyName, '청년 주거 지원');
      expect(policy.policyType, 'HOUSING');
      expect(policy.region, '11');
      expect(policy.institutionName, '서울시');
      expect(policy.departmentName, '청년정책과');
      expect(policy.startDate, '2024-01-01');
      expect(policy.endDate, '2024-12-31');
      expect(policy.applyUrl, 'https://apply');
      expect(policy.description, '설명');
      expect(policy.displayYn, 'N');
    });
  });

  group('Institution normalization', () {
    test('maps common field aliases', () {
      final institution = Institution.fromJson({
        'instNo': 'I-10',
        'instNm': '경상북도',
        'instIntrcn': '설명',
        'rgnSe': '47',
      });

      expect(institution.id, 'I-10');
      expect(institution.name, '경상북도');
      expect(institution.description, '설명');
      expect(institution.region, '47');
    });
  });

  group('Department normalization', () {
    test('maps common field aliases', () {
      final department = Department.fromJson({
        'deptNo': 'D-300',
        'deptNm': '청년지원과',
        'instNo': 'I-10',
        'deptIntrcn': '부서 설명',
      });

      expect(department.id, 'D-300');
      expect(department.name, '청년지원과');
      expect(department.institutionId, 'I-10');
      expect(department.description, '부서 설명');
    });
  });

  group('PolicyListResponse', () {
    test('parses non-boolean success flags', () {
      final response = PolicyListResponse.fromJson({
        'success': 'Y',
        'resultList': [
          {
            'policyId': '1',
            'policyNm': '테스트',
          }
        ],
      });

      expect(response.success, isTrue);
      expect(response.resultList, isNotNull);
      expect(response.resultList!.single.policyName, '테스트');
    });

    test('defaults to false when success is missing', () {
      final response = PolicyListResponse.fromJson({});
      expect(response.success, isFalse);
    });
  });
}
