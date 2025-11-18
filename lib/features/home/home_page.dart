import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../policy/controller/policy_list_controller.dart';
import '../policy/controller/policy_engagement_controller.dart';
import '../policy/data/models/policy.dart';
import '../policy/presentation/widgets/policy_card.dart';
import '../profile/providers/user_preferences_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policies = ref.watch(policyListControllerProvider);
    final recent = ref.watch(policyEngagementControllerProvider);
    final userRegion = ref.watch(userRegionProvider);
    final userInterests = ref.watch(userInterestsProvider);
    final recentPolicies = recent.maybeWhen(
      data: (state) => state.recentPolicies,
      orElse: () => const <Policy>[],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('추천 정책'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/home/search'),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => context.push('/home/bookmarks'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/home/settings'),
          ),
        ],
      ),
      body: policies.when(
        data: (items) => RefreshIndicator(
          onRefresh: () async {
            await ref.refresh(policyListControllerProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              _PolicySection(
                title: '맞춤 추천',
                description: '관심 분야와 행동을 기반으로 선별했어요.',
                policies: items.take(5).toList(),
              ),
              if (userRegion != null)
                _PolicySection(
                  title: '우리 지역 최신 정책',
                  description: '선택한 지역의 최신 소식을 모았어요.',
                  policies: _regionLatest(items, userRegion),
                ),
              _PolicySection(
                title: '마감 임박',
                description: '마감 전에 놓치지 마세요!',
                policies: _closingSoon(items),
              ),
              if (userInterests.isNotEmpty)
                _PolicySection(
                  title: '관심사 추천',
                  description: '관심 분야에서 새로 올라온 정책입니다.',
                  policies: _interestPolicies(items, userInterests),
                ),
              if (recentPolicies.isNotEmpty)
                _PolicySection(
                  title: '최근 본 정책',
                  description: '다시 확인할 수 있도록 모아두었습니다.',
                  policies: recentPolicies,
                ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('정책을 불러오지 못했습니다: $error')),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/home/search');
              break;
            case 2:
              context.go('/home/bookmarks');
              break;
            case 3:
              context.go('/home/unity-map');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.recommend), label: '추천'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: '북마크'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '지도'),
        ],
      ),
    );
  }

  static List<Policy> _regionLatest(List<Policy> policies, String region) {
    final filtered = policies.where((policy) => policy.regionCode == region).toList();
    filtered.sort((a, b) {
      final aDate = a.startDate ?? a.endDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.startDate ?? b.endDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return filtered.take(5).toList();
  }

  static List<Policy> _closingSoon(List<Policy> policies) {
    final now = DateTime.now();
    final closings = policies
        .where((policy) => policy.endDate != null && policy.endDate!.isAfter(now))
        .toList();
    closings.sort((a, b) => a.endDate!.compareTo(b.endDate!));
    return closings.take(5).toList();
  }

  static List<Policy> _interestPolicies(
    List<Policy> policies,
    List<String> interests,
  ) {
    return policies
        .where((policy) => policy.categories.any(interests.contains))
        .take(5)
        .toList();
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({
    required this.title,
    required this.description,
    required this.policies,
  });

  final String title;
  final String description;
  final List<Policy> policies;

  @override
  Widget build(BuildContext context) {
    if (policies.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) => SizedBox(
                width: 320,
                child: PolicyCard(policy: policies[index]),
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: policies.length,
            ),
          ),
        ],
      ),
    );
  }
}
