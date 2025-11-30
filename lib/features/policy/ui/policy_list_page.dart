import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/policy.dart';
import '../providers/policy_list_provider.dart';
import '../providers/policy_prefetch_provider.dart';

class PolicyListPage extends ConsumerWidget {
  const PolicyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(policyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('청년 정책'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(policyPrefetchProvider.notifier).prefetchPolicies(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '지금 바로 확인하세요',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '앱 실행과 동시에 정책을 준비하고 있어요. \n새로운 정보를 받는 동안에도 화면을 바로 볼 수 있습니다.',
                    ),
                  ],
                ),
              ),
            ),
            state.when(
              data: (policies) {
                if (policies.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text('표시할 정책이 없습니다. 새 데이터를 불러오고 있어요.'),
                      ),
                    ),
                  );
                }

                return SliverList.separated(
                  itemBuilder: (context, index) {
                    final policy = policies[index];
                    return _PolicyTile(policy: policy);
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemCount: policies.length,
                );
              },
              loading: () => const _LazyLoadingPlaceholder(),
              error: (error, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '정책 데이터를 불러오는 중에 문제가 발생했습니다.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text('$error'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(policyPrefetchProvider.notifier)
                            .prefetchPolicies(),
                        child: const Text('다시 불러오기'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  const _PolicyTile({required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (policy.rgnSeNm != null) policy.rgnSeNm!,
      if (policy.policyTypeNm != null) policy.policyTypeNm!,
      if (policy.isOngoing == true) '진행중',
    ].join(' · ');

    return ListTile(
      title: Text(policy.policyNm),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: policy.dday != null
          ? Chip(label: Text('D-${policy.dday}'))
          : null,
    );
  }
}

class _LazyLoadingPlaceholder extends StatelessWidget {
  const _LazyLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _PlaceholderTile(),
          );
        },
        childCount: 8,
      ),
    );
  }
}

class _PlaceholderTile extends StatelessWidget {
  const _PlaceholderTile();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 16,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          width: 180,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
