import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/error_view.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/youth_app_bar.dart';
import '../../data/model/policy_models.dart';
import '../region/region_provider.dart';
import 'local/favorite_policies_notifier.dart';
import 'local/recent_policies_notifier.dart';
import 'policy_filter.dart';
import 'policy_list_notifier.dart';
import 'policy_list_state.dart';
import 'widgets/policy_card.dart';

class PolicyListScreen extends ConsumerStatefulWidget {
  const PolicyListScreen({super.key});

  @override
  ConsumerState<PolicyListScreen> createState() => _PolicyListScreenState();
}

class _PolicyListScreenState extends ConsumerState<PolicyListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedYear;
  final List<String> _policyTypeOptions = <String>[
    '청년일자리',
    '주거',
    '복지문화',
    '교육',
    '참여권리',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(policyListNotifierProvider.notifier).fetchPolicies(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final PolicyListState state = ref.watch(policyListNotifierProvider);
    final favoriteIds = ref.watch(favoritePoliciesProvider).maybeWhen(
          data: (data) => data,
          orElse: () => <String>[],
        );
    final region = ref.watch(selectedRegionProvider);

    return Scaffold(
      appBar: YouthAppBar(
        title: '정책 목록',
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => context.push('/map'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(policyListNotifierProvider.notifier).fetchPolicies(refresh: true),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RegionBanner(regionName: region?.name ?? '지역 선택 필요', onTap: () => context.push('/region/select')),
                    const SizedBox(height: 12),
                    _buildSearchBar(),
                    const SizedBox(height: 12),
                    _buildFilters(state),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (state.isLoading && state.items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: LoadingView(fullscreen: true),
                    )
                  else if (state.error != null && state.items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: ErrorView(
                        message: state.error!.message,
                        fullscreen: true,
                        onRetry: () => ref.read(policyListNotifierProvider.notifier).fetchPolicies(refresh: true),
                      ),
                    )
                  else
                    ...state.items.map(
                      (policy) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: PolicyCard(
                          policy: policy,
                          isFavorite: favoriteIds.contains(policy.no ?? ''),
                          onFavoriteToggle: () => ref.read(favoritePoliciesProvider.notifier).toggle(policy.no ?? ''),
                          onTap: () async {
                            await ref.read(recentPoliciesProvider.notifier).addRecent(policy);
                            context.push('/policy/detail/${policy.no ?? ''}', extra: policy);
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (state.isLoadingMore) const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  if (!state.isLoading && state.hasNext)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: OutlinedButton(
                        onPressed: () => ref.read(policyListNotifierProvider.notifier).fetchMore(),
                        child: const Text('더 보기'),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: '정책명을 입력하세요',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (value) => ref.read(policyListNotifierProvider.notifier).setSearchKeyword(value),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => ref.read(policyListNotifierProvider.notifier).setSearchKeyword(_searchController.text),
          icon: const Icon(Icons.search),
          label: const Text('검색'),
        ),
      ],
    );
  }

  Widget _buildFilters(PolicyListState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('정책 유형', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _policyTypeOptions
              .map(
                (type) => FilterChip(
                  label: Text(type),
                  selected: state.filter.policyTypes.contains(type),
                  onSelected: (_) => ref.read(policyListNotifierProvider.notifier).togglePolicyType(type),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String?>(
                value: _selectedYear,
                decoration: const InputDecoration(
                  labelText: '연도',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: <String?>[null, '2024', '2025', '2026']
                    .map(
                      (year) => DropdownMenuItem<String?>(
                        value: year,
                        child: Text(year ?? '전체'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedYear = value);
                  ref.read(policyListNotifierProvider.notifier).setSearchYear(value);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SwitchListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('신청 가능만'),
                value: state.filter.onlyAvailable,
                onChanged: (v) => ref.read(policyListNotifierProvider.notifier).setOnlyAvailable(v),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _RegionBanner extends StatelessWidget {
  const _RegionBanner({required this.regionName, required this.onTap});

  final String regionName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('선택 지역', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(regionName, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
