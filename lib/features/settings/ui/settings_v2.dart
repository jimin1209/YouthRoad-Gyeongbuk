import 'package:flutter/material.dart';

/// 간결한 설정 V2 화면 (UI-only, mock 데이터).
class SettingsV2Page extends StatelessWidget {
  const SettingsV2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _regionBanner(context, regionName: '경북 전체'),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('캐시 초기화'),
              subtitle: const Text('즐겨찾기 / 최근 본 초기화'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('앱 정보'),
              subtitle: const Text('버전 1.0.0 · YouthRoad'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _regionBanner(BuildContext context, {required String regionName}) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.place),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('현재 지역', style: Theme.of(context).textTheme.bodySmall),
                Text(regionName, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('변경')),
        ],
      ),
    );
  }
}
