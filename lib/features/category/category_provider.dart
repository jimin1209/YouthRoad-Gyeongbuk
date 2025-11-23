import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';

final categoryPoliciesProvider = Provider<Map<String, List<Policy>>>((_) {
  return {
    '창업': const [
      Policy(
        id: 'c1',
        policyNm: '창업 패스트트랙',
        policyCn: '초기 창업팀 보육 및 자금 패키지',
        tags: ['창업', '보육'],
      ),
    ],
    '주거': const [
      Policy(
        id: 'c2',
        policyNm: '청년 주거 바우처',
        policyCn: '월세·전세 보증금 일부 지원',
        tags: ['주거', '바우처'],
      ),
    ],
  };
});
