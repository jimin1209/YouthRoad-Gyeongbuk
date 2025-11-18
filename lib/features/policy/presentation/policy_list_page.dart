import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/policy_list_controller.dart';
import '../controller/policy_metadata_providers.dart';
import '../../region/providers/providers.dart';
import 'widgets/policy_card.dart';

class PolicyListPage extends ConsumerWidget {
  const PolicyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policiesAsync = ref.watch(policyListControllerProvider);
    final filter = ref.watch(policyFilterProvider);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(policyListControllerProvider.future),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _FilterSection(filter: filter),
          ),
          ...policiesAsync.when(
            data: (policies) {
              if (policies.isEmpty) {
                return const [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyPoliciesView(),
                  ),
                ];
              }
              return [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => PolicyCard(policy: policies[index]),
                    childCount: policies.length,
                  ),
                ),
              ];
            },
            loading: () => [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const PolicyCardSkeleton(),
                  childCount: 4,
                ),
              ),
            ],
            error: (e, _) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: _ErrorView(message: '불러오지 못했습니다: $e'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends ConsumerWidget {
  const _FilterSection({required this.filter});

  final PolicyFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regions = ref.watch(regionListProvider);
    final categories = ref.watch(categoryListProvider);
    final statusOptions = const {
      'OPEN': '모집중',
      'CLOSED': '마감',
      'UPCOMING': '예정',
    };
    final normalizedStatus =
        filter.status != null && statusOptions.containsKey(filter.status)
            ? filter.status
            : null;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '정책 필터',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(policyFilterUseProfileProvider.notifier).state = true;
                    ref.read(policyFilterStateProvider.notifier).state = PolicyFilter.initial();
                  },
                  child: const Text('초기화'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            regions.when(
              data: (items) {
                final selectedRegion = items.any((region) => region.code == filter.region)
                    ? filter.region
                    : null;
                return DropdownButtonFormField<String?>(
                  value: selectedRegion,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: '지역'),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('전체')),
                    ...items.map(
                      (region) => DropdownMenuItem(
                        value: region.code,
                        child: Text(region.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    ref.read(policyFilterUseProfileProvider.notifier).state =
                        false;
                    final notifier = ref.read(policyFilterStateProvider.notifier);
                    notifier.state = notifier.state.copyWith(region: value);
                  },
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('지역 정보를 불러오지 못했습니다: $error'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              value: normalizedStatus,
              isExpanded: true,
              decoration: const InputDecoration(labelText: '상태'),
              items: [
                const DropdownMenuItem<String?>(value: null, child: Text('전체')),
                ...statusOptions.entries.map(
                  (entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  ),
                ),
              ],
              onChanged: (value) {
                ref.read(policyFilterUseProfileProvider.notifier).state = false;
                final notifier = ref.read(policyFilterStateProvider.notifier);
                notifier.state = notifier.state.copyWith(status: value);
              },
            ),
            const SizedBox(height: 12),
            Text('관심 분야', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            categories.when(
              data: (items) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items.map((category) {
                  final selected = filter.categories.contains(category.code);
                  return FilterChip(
                    label: Text(category.name),
                    selected: selected,
                    onSelected: (value) {
                      ref
                          .read(policyFilterUseProfileProvider.notifier)
                          .state = false;
                      final notifier = ref.read(policyFilterStateProvider.notifier);
                      final current = [...notifier.state.categories];
                      if (value) {
                        if (!current.contains(category.code)) {
                          current.add(category.code);
                        }
                      } else {
                        current.remove(category.code);
                      }
                      notifier.state = notifier.state.copyWith(categories: current);
                    },
                  );
                }).toList(),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('카테고리를 불러오지 못했습니다: $error'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPoliciesView extends StatelessWidget {
  const _EmptyPoliciesView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 56, color: theme.colorScheme.outline),
          const SizedBox(height: 12),
          Text('조건에 맞는 정책이 없습니다.', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            '필터를 조정하거나 다른 키워드로 다시 검색해보세요.',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 56, color: theme.colorScheme.error),
          const SizedBox(height: 12),
          Text(message, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
