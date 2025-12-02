import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/values/policy_failure.dart';

class PolicyHomeNewScreen extends ConsumerWidget {
  const PolicyHomeNewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(policyPagingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('새 정책 홈 (PolicyNew)'),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Text(
            e is PolicyFailure ? e.message : e.toString(),
          ),
        ),
        data: (policies) {
          if (policies.isEmpty) {
            return const Center(
              child: Text('표시할 정책이 없습니다.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(policyPagingControllerProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: policies.length,
              itemBuilder: (context, index) {
                final p = policies[index];
                return ListTile(
                  title: Text(p.title),
                  subtitle: Text(
                    '${p.region} / '
                    '${p.applicationStartDate?.toIso8601String() ?? '-'}'
                    ' ~ '
                    '${p.applicationEndDate?.toIso8601String() ?? '-'}',
                  ),
                  onTap: () {
                    // 이후 job에서 상세 화면 라우팅 연결 예정
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(policyPagingControllerProvider.notifier).loadNextPage();
        },
        child: const Icon(Icons.expand_more),
      ),
    );
  }
}
