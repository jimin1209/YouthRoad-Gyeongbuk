import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../policy/local/favorite_policies_notifier.dart';
import '../policy/local/local_policy_store.dart';
import '../policy/local/recent_policies_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.place),
            title: const Text('지역 재선택'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/region/select'),
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('캐시 초기화'),
            subtitle: const Text('최근 본 정책, 찜 목록을 삭제합니다'),
            onTap: () async {
              await ref.read(localPolicyStoreProvider).clearAll();
              await ref.read(recentPoliciesProvider.notifier).clear();
              await ref.read(favoritePoliciesProvider.notifier).load();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('캐시를 초기화했습니다.')),
                );
              }
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('앱 정보'),
            subtitle: Text('YouthRoad-Gyeongbuk'),
          ),
        ],
      ),
    );
  }
}
