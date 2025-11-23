import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers.dart';
import '../../../application/services/eligibility_service.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/policy_card_v2.dart';

class PolicyCompareScreen extends ConsumerWidget {
  const PolicyCompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareAsync = ref.watch(compareProvider);
    final selectedRegion = ref.watch(regionProvider);

    return Scaffold(
      appBar: const AppAppBar(title: '정책 비교'),
      body: compareAsync.when(
        data: (policies) {
          if (policies.isEmpty) {
            return const Center(child: Text('비교 대상 정책을 추가해보세요.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: policies.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final p = policies[i];
              final result = EligibilityService().evaluate(
                policy: p,
                userAge: null,
                userRegion: selectedRegion,
              );
              final eligibilityText = _mapEligibilityResult(result);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PolicyCardV2(policy: p),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('지원 가능 여부: $eligibilityText'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () =>
                          ref.read(compareProvider.notifier).remove(p.id),
                      icon: const Icon(Icons.remove_circle_outline),
                      label: const Text('비교함에서 제거'),
                    ),
                  ),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('비교 정보를 불러올 수 없습니다: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ref.read(compareProvider.notifier).clear(),
        icon: const Icon(Icons.clear_all),
        label: const Text('비우기'),
      ),
    );
  }

  String _mapEligibilityResult(EligibilityResult result) {
    switch (result) {
      case EligibilityResult.eligible:
        return 'Y';
      case EligibilityResult.notEligible:
        return 'N';
      case EligibilityResult.unknown:
        return '정보 없음';
    }
  }
}
