import '../../models/policy_filter.dart';
import '../../models/policy_model.dart';

class LocalPolicySource {
  static const _mockPoliciesJson = [
    {
      'no': '100',
      'policyNm': '경북 청년 창업 지원',
      'policyYr': '2024',
      'rgnSeNm': '경상북도',
      'policyTypeNm': '창업',
      'sprvsnInstNm': '경상북도청',
      'operInstNm': '경북테크노파크',
      'policyBgngYmd': '2024-01-01',
      'policyEndYmd': '2024-12-31',
      'policyScl': '총 100억 원 규모',
      'policyCn': '창업 초기 자금과 컨설팅을 지원합니다.',
      'policyEnq': '053-000-0000',
      'aplyYn': 'Y',
      'aplyBgngDt': '2024-02-01',
      'aplyEndDt': '2024-03-15',
      'aplyPsbltyYn': 'Y',
      'dtlLinkUrl': 'https://example.com/policy/100',
      'dsplyYn': 'Y',
      'crtDt': '2023-12-01',
      'updtDt': '2024-01-05',
      'tags': ['창업', '자금', '멘토링'],
      'dday': 60,
      'isOngoing': true,
    },
    {
      'no': '101',
      'policyNm': '청년 주거 안정 지원',
      'policyYr': '2023',
      'rgnSeNm': '대구',
      'policyTypeNm': '주거',
      'sprvsnInstNm': '국토교통부',
      'operInstNm': '한국토지주택공사',
      'policyBgngYmd': '2023-05-01',
      'policyEndYmd': '2024-04-30',
      'policyScl': '월세 지원 최대 20만 원',
      'policyCn': '청년 월세를 지원하는 사업입니다.',
      'policyEnq': '02-123-4567',
      'aplyYn': 'N',
      'aplyBgngDt': '2023-05-01',
      'aplyEndDt': '2023-06-15',
      'aplyPsbltyYn': 'N',
      'dtlLinkUrl': 'https://example.com/policy/101',
      'dsplyYn': 'Y',
      'crtDt': '2023-04-10',
      'updtDt': '2023-11-20',
      'tags': ['주거', '월세'],
      'dday': -10,
      'isOngoing': false,
    },
    {
      'no': '102',
      'policyNm': '청년 문화 활동 바우처',
      'policyYr': '2024',
      'rgnSeNm': '전국',
      'policyTypeNm': '문화',
      'sprvsnInstNm': '문화체육관광부',
      'operInstNm': '한국문화예술위원회',
      'policyBgngYmd': '2024-03-01',
      'policyEndYmd': '2024-09-30',
      'policyScl': '1인당 연 30만 원',
      'policyCn': '문화 활동을 위한 바우처를 제공합니다.',
      'policyEnq': '02-555-0000',
      'aplyYn': 'Y',
      'aplyBgngDt': null,
      'aplyEndDt': null,
      'aplyPsbltyYn': null,
      'dtlLinkUrl': 'https://example.com/policy/102',
      'dsplyYn': 'N',
      'crtDt': '2024-01-20',
      'updtDt': '2024-02-12',
      'tags': ['문화', '바우처', '지원'],
      'dday': 120,
      'isOngoing': true,
    },
  ];

  Future<List<PolicyModel>> fetchDummyPolicies({PolicyFilter? filter}) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _mockPoliciesJson.map((e) => PolicyModel.fromJson(e)).toList();
  }

  Future<PolicyModel> fetchDummyPolicy(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final list = _mockPoliciesJson.map((e) => PolicyModel.fromJson(e)).toList();
    return list.firstWhere((p) => p.id == id);
  }

  Future<List<PolicyModel>> fetchSimilar(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return const [];
  }
}
