import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/app_appbar.dart';
import '../../widgets/policy_card.dart';
import '../../../features/category/category_provider.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(categoryPoliciesProvider);

    return Scaffold(
      appBar: const AppAppBar(title: '카테고리별 탐색'),
      body: categoryState.when(
        data: (state) {
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(categoryPoliciesProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Text(
                  '총 ${state.totalCount}개 정책을 카테고리별로 정리했어요',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (state.region != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '선택 지역: ${state.region}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[700]),
                    ),
                  ),
                const SizedBox(height: 16),
                ...state.categories.entries.map(
                  (entry) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Chip(
                            label: Text('${entry.value.length}개'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (entry.value.isEmpty)
                        _EmptyCategoryHint(
                          onRelaxFilters: () => ref
                              .read(categoryPoliciesProvider.notifier)
                              .refresh(includeAllRegions: true),
                        )
                      else
                        ...entry.value.map(
                          (policy) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: PolicyCard(policy: policy),
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                if (state.fallbackPolicies.isNotEmpty) ...[
                  Text(
                    '이 카테고리와 함께 보면 좋은 정책',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...state.fallbackPolicies.map(
                    (policy) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PolicyCard(policy: policy),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('정책을 불러오는 중 문제가 발생했습니다.'),
              const SizedBox(height: 8),
              Text('$error'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () =>
                    ref.read(categoryPoliciesProvider.notifier).refresh(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCategoryHint extends StatelessWidget {
  const _EmptyCategoryHint({required this.onRelaxFilters});

  final VoidCallback onRelaxFilters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '해당 카테고리에 진행중인 정책이 없습니다.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text('필터를 완화하거나 다른 카테고리를 함께 살펴보세요.'),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onRelaxFilters,
            child: const Text('전체 지역으로 다시 불러오기'),
          ),
        ),
      ],
    );
  }
}
