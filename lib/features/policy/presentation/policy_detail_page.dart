import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/policy_detail_controller.dart';

class PolicyDetailPage extends ConsumerWidget {
  const PolicyDetailPage({super.key, required this.policyId});
  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policyAsync = ref.watch(policyDetailControllerProvider(policyId));
    return Scaffold(
      appBar: AppBar(title: const Text('정책 상세')),
      body: policyAsync.when(
        data: (policy) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text(policy.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(policy.summary),
              const Divider(),
              Text('지역: ${policy.regionName}'),
              Text('지원 대상: ${policy.minAge}~${policy.maxAge}세, ${policy.targetGroups.join(', ')}'),
              const SizedBox(height: 12),
              Text('지원 내용', style: Theme.of(context).textTheme.titleMedium),
              Text(policy.supportDetail),
              const SizedBox(height: 12),
              Text('신청 방법: ${policy.applicationMethod}'),
              TextButton(
                onPressed: () {
                  // TODO: open applicationUrl
                },
                child: const Text('신청 페이지 열기'),
              ),
              const SizedBox(height: 12),
              Text('문의처: ${policy.contact}'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: bookmark toggle
                },
                child: const Text('북마크'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  // TODO: unity map navigation
                },
                child: const Text('지도에서 위치 보기'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('불러오지 못했습니다: $e')),
      ),
    );
  }
}
