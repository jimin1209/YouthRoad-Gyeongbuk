import '../../models/policy_model.dart';

class LocalPolicySource {
  Future<List<PolicyModel>> fetchDummyPolicies() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const [
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
    ];
  }
}
