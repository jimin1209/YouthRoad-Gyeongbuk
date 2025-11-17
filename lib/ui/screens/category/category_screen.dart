import 'package:flutter/material.dart';

import '../../widgets/app_appbar.dart';
import '../../widgets/policy_card.dart';
import '../../../domain/entities/policy.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = <String, List<Policy>>{
      '창업': [
        const Policy(
          id: 'c1',
          title: '창업 패스트트랙',
          category: '창업',
          summary: '초기 창업팀 보육 및 자금 패키지',
          tags: ['창업', '보육'],
        ),
      ],
      '주거': [
        const Policy(
          id: 'c2',
          title: '청년 주거 바우처',
          category: '주거',
          summary: '월세·전세 보증금 일부 지원',
          tags: ['주거', '바우처'],
        ),
      ],
    };

    return Scaffold(
      appBar: const AppAppBar(title: '카테고리별 탐색'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: categories.entries
            .map(
              (entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.key,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...entry.value.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PolicyCard(policy: p),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
