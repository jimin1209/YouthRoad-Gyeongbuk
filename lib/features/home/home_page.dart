import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../policy/controller/policy_list_controller.dart';
import '../policy/controller/policy_engagement_controller.dart';
import '../policy/data/models/policy.dart';
import '../policy/presentation/widgets/policy_card.dart';
import '../profile/providers/user_preferences_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final PageController _bannerController;
  double _bannerPosition = 0;

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.9)
      ..addListener(() {
        setState(() {
          _bannerPosition = _bannerController.page ?? 0;
        });
      });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('안녕하세요, 청년님', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/home/search'),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () => context.push('/home/bookmarks'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/home/settings'),
          ),
        ],
      ),
      body: policies.when(
        data: (items) {
          final featured = items.take(6).toList();
          final regionLatest = userRegion != null ? _regionLatest(items, userRegion) : const <Policy>[];
          final closingSoon = _closingSoon(items);
          final interestPolicies =
              userInterests.isNotEmpty ? _interestPolicies(items, userInterests) : const <Policy>[];
          return RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(policyListControllerProvider.future);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _UserGreetingCard(regionCode: userRegion, interests: userInterests),
                        const SizedBox(height: 20),
                        _BannerCarousel(
                          controller: _bannerController,
                          position: _bannerPosition,
                          regionName: userRegion,
                        ),
                      ],
                    ),
                  ),
                ),
                _SectionSliver(
                  title: '추천 정책',
                  subtitle: '관심사와 행동 데이터를 기반으로 고른 맞춤 추천',
                  policies: featured,
                ),
                if (regionLatest.isNotEmpty)
                  _SectionSliver(
                    title: '우리 지역 최신 소식',
                    subtitle: '방금 등록된 우리 지역 정책',
                    policies: regionLatest,
                  ),
                if (closingSoon.isNotEmpty)
                  _SectionSliver(
                    title: '마감 임박',
                    subtitle: '마감 전에 빠르게 지원해보세요',
                    policies: closingSoon,
                    badgeColor: Theme.of(context).colorScheme.errorContainer,
                  ),
                if (interestPolicies.isNotEmpty)
                  _SectionSliver(
                    title: '관심사 추천',
                    subtitle: '선호 카테고리에 꼭 맞는 정책',
                    policies: interestPolicies,
                  ),
                if (recentPolicies.isNotEmpty)
                  SliverToBoxAdapter(child: _RecentListSection(policies: recentPolicies)),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
        loading: () => const _HomeLoadingView(),
        error: (error, _) => _HomeErrorView(message: '정책을 불러오지 못했습니다: $error'),
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
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize_outlined), label: '대시보드'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: '북마크'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '지도'),
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

class _HomeLoadingView extends StatelessWidget {
  const _HomeLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: const [
        _LoadingHeader(),
        SizedBox(height: 12),
        PolicyCardSkeleton(),
        PolicyCardSkeleton(),
        PolicyCardSkeleton(),
      ],
    );
  }
}

class _LoadingHeader extends StatelessWidget {
  const _LoadingHeader();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
          ),
          const SizedBox(height: 12),
          Container(
            height: 150,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
          ),
        ],
      ),
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  const _HomeErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(message, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _SectionSliver extends StatelessWidget {
  const _SectionSliver({
    required this.title,
    required this.subtitle,
    required this.policies,
    this.badgeColor,
  });

  final String title;
  final String subtitle;
  final List<Policy> policies;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    if (policies.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  if (badgeColor != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'HOT',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) => SizedBox(
                  width: 320,
                  child: PolicyCard(policy: policies[index], margin: EdgeInsets.zero),
                ),
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemCount: policies.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserGreetingCard extends StatelessWidget {
  const _UserGreetingCard({required this.regionCode, required this.interests});

  final String? regionCode;
  final List<String> interests;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('오늘도 성장 중인 청년님,', style: textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              regionCode == null ? '지역을 선택하고 더 정확한 추천을 받아보세요.' : '현재 설정 지역: $regionCode',
              style: textTheme.bodyMedium?.copyWith(color: textTheme.bodySmall?.color),
            ),
            const SizedBox(height: 12),
            if (interests.isNotEmpty)
              Wrap(
                spacing: 8,
                children: interests.take(4).map((interest) => Chip(label: Text('#$interest'))).toList(),
              )
            else
              Text('관심 분야를 선택하면 맞춤 추천이 더 정확해져요!', style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _BannerCarousel extends StatelessWidget {
  const _BannerCarousel({
    required this.controller,
    required this.position,
    required this.regionName,
  });

  final PageController controller;
  final double position;
  final String? regionName;

  @override
  Widget build(BuildContext context) {
    final banners = [
      '청년 맞춤 정책을 지금 바로 확인해보세요.',
      '마감 임박 정책을 놓치지 않도록 알림을 켜보세요.',
      if (regionName != null) '$regionName 청년을 위한 새로운 지원이 열렸어요!'
    ];
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: controller,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        banners[index],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
            final isActive = (position.round() == index);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _RecentListSection extends StatelessWidget {
  const _RecentListSection({required this.policies});

  final List<Policy> policies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('최근 본 정책', style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) => SizedBox(
                width: 240,
                child: _RecentPolicyCard(policy: policies[index]),
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

class _RecentPolicyCard extends StatelessWidget {
  const _RecentPolicyCard({required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/home/policy/${policy.id}'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              policy.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Text(
              policy.summary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(policy.regionName, style: Theme.of(context).textTheme.labelMedium),
                Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
