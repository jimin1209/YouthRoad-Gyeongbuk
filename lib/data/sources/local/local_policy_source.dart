import '../../models/policy_model.dart';

class LocalPolicySource {
  static const _mockPolicies = [
    PolicyModel(
      id: 'p1',
      title: '청년 창업 지원',
      category: '창업',
      summary: '경북 청년 대상 창업 자금·멘토링 지원',
      tags: ['창업', '자금', '멘토링'],
      policyUrl: 'https://example.com/policies/p1',
      agency: '경상북도경제진흥원',
      department: '창업지원과',
      eligibilityAge: 34,
      eligibilityRegion: '경상북도',
      applicationMethod: '온라인 신청 후 서류 심사',
      requiredDocuments: '사업계획서, 주민등록등본',
      contact: '054-000-1234',
      periodStart: '2024-01-01',
      periodEnd: '2024-12-31',
      dday: 90,
      isOngoing: true,
    ),
    PolicyModel(
      id: 'p2',
      title: '주거 안정 패키지',
      category: '주거',
      summary: '전세자금 보증 및 임대료 일부 지원',
      tags: ['주거', '보증', '임대료'],
      policyUrl: 'https://example.com/policies/p2',
      agency: '경북주택도시공사',
      department: '주거복지팀',
      eligibilityAge: 39,
      eligibilityRegion: '포항시',
      applicationMethod: '현장 접수 및 온라인 병행',
      requiredDocuments: '신분증, 소득증빙서류',
      contact: '054-100-2222',
      periodStart: '2024-02-15',
      periodEnd: '2024-11-30',
      dday: 45,
      isOngoing: false,
    ),
    PolicyModel(
      id: 'p3',
      title: '지역 문화 활동비',
      category: '문화',
      summary: '지역 기반 문화 활동비 및 네트워킹 지원',
      tags: ['문화', '네트워킹'],
      policyUrl: 'https://example.com/policies/p3',
      agency: '경북문화재단',
      department: '문화사업팀',
      eligibilityAge: 29,
      eligibilityRegion: '경산시',
      applicationMethod: '온라인 접수 후 인터뷰',
      requiredDocuments: '활동계획서',
      contact: '054-200-3333',
      periodStart: '2024-03-01',
      periodEnd: '2024-09-30',
      dday: 15,
      isOngoing: false,
    ),
    PolicyModel(
      id: 'p4',
      title: '취업 역량 강화',
      category: '취업',
      summary: '면접·자격증 지원과 멘토링 제공',
      tags: ['취업', '멘토링'],
      policyUrl: 'https://example.com/policies/p4',
      agency: '경북일자리재단',
      department: '청년취업팀',
      eligibilityAge: 34,
      eligibilityRegion: '구미시',
      applicationMethod: '온라인 신청 후 오프라인 교육',
      requiredDocuments: '이력서, 자격증 사본',
      contact: '054-300-4444',
      periodStart: '2024-04-10',
      periodEnd: '2024-12-10',
      dday: 120,
      isOngoing: true,
    ),
    PolicyModel(
      id: 'p5',
      title: '교육비 지원',
      category: '교육',
      summary: '직무 교육비와 학습 플랫폼 이용권 지원',
      tags: ['교육', '학습'],
      policyUrl: 'https://example.com/policies/p5',
      agency: '경북청년재단',
      department: '교육지원팀',
      eligibilityAge: 30,
      eligibilityRegion: '안동시',
      applicationMethod: '온라인 신청',
      requiredDocuments: '교육 신청서',
      contact: '054-500-5555',
      periodStart: '2024-05-01',
      periodEnd: '2024-08-31',
      dday: 7,
      isOngoing: false,
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
