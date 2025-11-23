import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/policy_card.dart';

class MapWithListScreen extends ConsumerWidget {
  const MapWithListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policies = ref.watch(policyListNotifierProvider);
    return Scaffold(
      appBar: const AppAppBar(title: '지도 + 리스트'),
      body: Column(
        children: [
          SizedBox(
            height: 220,
            child: const KakaoMapPlaceholder(),
          ),
          Expanded(
            child: policies.when(
              data: (data) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, i) => PolicyCard(policy: data[i]),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: data.length,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('정책을 불러오지 못했습니다: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class KakaoMapPlaceholder extends StatelessWidget {
  const KakaoMapPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      alignment: Alignment.center,
      child: const Text('카카오맵 미리보기 (웹뷰 전용 화면에서 전체 보기)'),
    );
  }
}
