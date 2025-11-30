import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/providers.dart';
import '../../../application/policy/policy_list_notifier.dart';
import '../../../navigation/route_paths.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/global_error_view.dart';
import '../../widgets/policy_card_v2.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(policyListNotifierProvider);
    final notifier = ref.read(policyListNotifierProvider.notifier);
    final region = ref.watch(regionProvider) ?? '지역을 선택해주세요';

    final policies = state.policies;

    Widget body;
    if (state.isLoading && policies.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (state.error != null && policies.isEmpty) {
      body = GlobalErrorView(
        message: PolicyListNotifier.errorMessage,
        onRetry: notifier.refresh,
      );
    } else {
      body = RefreshIndicator(
        onRefresh: notifier.refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _RegionBanner(region: region),
            const SizedBox(height: 12),
            _QuickActions(),
            const SizedBox(height: 16),
            Text('추천 정책', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (state.isStale)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('캐시된 데이터 표시 중... 최신 정보를 불러오는 중입니다.'),
              ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, i) => PolicyCardV2(
                policy: policies[i],
                onTap: () => context.push(RoutePaths.policyDetail(policies[i].id)),
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: policies.length,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: const AppAppBar(title: '청년 정책 추천'),
      body: body,
    );
  }
}

class _RegionBanner extends StatelessWidget {
  const _RegionBanner({required this.region});

  final String region;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(region),
        subtitle: const Text('원하는 지역을 선택하면 맞춤 정책을 추천합니다.'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => context.push(RoutePaths.regionSelect),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ActionChip(
          label: '정책 검색 v2',
          icon: Icons.search,
          onTap: () => context.push(RoutePaths.policyListV2),
        ),
        _ActionChip(
          label: 'AI 챗',
          icon: Icons.chat,
          onTap: () => context.push(RoutePaths.chatbot),
        ),
        _ActionChip(
          label: 'Unity 지도',
          icon: Icons.map,
          onTap: () => context.push(RoutePaths.unity),
        ),
        _ActionChip(
          label: '카카오맵',
          icon: Icons.pin_drop,
          onTap: () => context.push(RoutePaths.googleMap),
        ),
        _ActionChip(
          label: '지도+리스트',
          icon: Icons.layers,
          onTap: () => context.push(RoutePaths.mapWithList),
        ),
        _ActionChip(
          label: '기관/부서',
          icon: Icons.business,
          onTap: () => context.push(RoutePaths.instList),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
