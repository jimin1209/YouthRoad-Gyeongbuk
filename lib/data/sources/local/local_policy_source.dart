import '../../models/policy_model.dart';

class LocalPolicySource {
  static const _mockPolicies = [
    PolicyModel(
      id: 'p1',
      title: '청년 창업 지원',
      category: '창업',
      summary: '경북 청년 대상 창업 자금·멘토링 지원',
      tags: ['창업', '자금', '멘토링'],
    ),
    PolicyModel(
      id: 'p2',
      title: '주거 안정 패키지',
      category: '주거',
      summary: '전세자금 보증 및 임대료 일부 지원',
      tags: ['주거', '보증', '임대료'],
    ),
    PolicyModel(
      id: 'p3',
      title: '지역 문화 활동비',
      category: '문화',
      summary: '지역 기반 문화 활동비 및 네트워킹 지원',
      tags: ['문화', '네트워킹'],
    ),
    PolicyModel(
      id: 'p4',
      title: '취업 역량 강화',
      category: '취업',
      summary: '면접·자격증 지원과 멘토링 제공',
      tags: ['취업', '멘토링'],
    ),
    PolicyModel(
      id: 'p5',
      title: '교육비 지원',
      category: '교육',
      summary: '직무 교육비와 학습 플랫폼 이용권 지원',
      tags: ['교육', '학습'],
    ),
  ];

  Future<List<PolicyModel>> fetchDummyPolicies({int page = 1}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // simple paging by cycling mock data
    final start = (page - 1) % _mockPolicies.length;
    final result = <PolicyModel>[];
    for (var i = 0; i < _mockPolicies.length; i++) {
      result.add(_mockPolicies[(start + i) % _mockPolicies.length]);
    }
    return result;
  }

  Future<PolicyModel> fetchDummyPolicy(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _mockPolicies.firstWhere(
      (p) => p.id == id,
      orElse: () => _mockPolicies.first,
    );
  }

  Future<List<PolicyModel>> fetchSimilar(String id) async {
    final base = await fetchDummyPolicy(id);
    return _mockPolicies
        .where((p) => p.id != base.id && p.category == base.category)
        .toList();
  }
}
