import 'package:flutter/material.dart';

import 'package:youth_road_app/feature/map/youth_unity_map_view.dart';
import '../../policy/ui/card/policy_card_v2.dart';

/// 지도 + 하단 미니 정책 리스트 결합 화면 (mock 데이터).
class MapWithListPage extends StatelessWidget {
  const MapWithListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mockPolicies = List.generate(
      5,
      (i) => (
        title: '정책 ${i + 1}',
        summary: '정책 ${i + 1} 요약 텍스트가 여기에 표시됩니다.',
        agency: '주관기관 ${i + 1}',
        dept: '부서 ${i + 1}',
        type: '유형',
        dDay: '${7 - i}',
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('지도와 정책 한 화면')),
      body: Column(
        children: [
          const Expanded(
            flex: 7,
            child: YouthUnityMapView(),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: mockPolicies.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final item = mockPolicies[i];
                  return PolicyCardV2(
                    title: item.title,
                    summary: item.summary,
                    agency: item.agency,
                    department: item.dept,
                    policyType: item.type,
                    dDayText: item.dDay,
                    eligibility: EligibilityBadge.eligible,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
