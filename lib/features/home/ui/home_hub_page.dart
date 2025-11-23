import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:youth_road_app/feature/region/region_provider.dart';

class HomeHubPage extends ConsumerWidget {
  const HomeHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final region = ref.watch(selectedRegionProvider);
    final regionText = region?.name ?? '지역 미선택';
    return Scaffold(
      appBar: AppBar(title: const Text('YouthRoad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RegionBanner(
              regionText: regionText,
              onTap: () => context.push('/region/select'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _HubCard(
                    icon: Icons.search,
                    title: '정책 검색하기',
                    description: '지역/유형/신청가능 필터로 빠르게 찾기',
                    onTap: () => context.push('/policy/list/v2'),
                  ),
                  const SizedBox(height: 16),
                  _HubCard(
                    icon: Icons.smart_toy,
                    title: 'AI 정책 상담하기',
                    description: '궁금한 점을 AI에게 물어보세요 (mock)',
                    onTap: () => context.push('/ai_chat'),
                  ),
                  const SizedBox(height: 16),
                  _HubCard(
                    icon: Icons.map,
                    title: '지도에서 찾아보기',
                    description: 'Google 지도에서 바로 보기',
                    onTap: () => context.push('/google_map'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegionBanner extends StatelessWidget {
  const _RegionBanner({required this.regionText, required this.onTap});

  final String regionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.place),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('현재 지역', style: Theme.of(context).textTheme.bodySmall),
                  Text(regionText, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            TextButton(onPressed: onTap, child: const Text('변경')),
          ],
        ),
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  const _HubCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: scheme.surfaceVariant,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: scheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: scheme.onSurface.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
