import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/providers.dart';
import '../../widgets/app_appbar.dart';

class SettingV2Screen extends ConsumerWidget {
  const SettingV2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final region = ref.watch(regionProvider) ?? '미선택';
    return Scaffold(
      appBar: const AppAppBar(title: '설정 v2'),
      body: ListView(
        children: [
          ListTile(
            title: const Text('현재 지역'),
            subtitle: Text(region),
            trailing: const Icon(Icons.map),
            onTap: () => ref.read(regionProvider.notifier).clear(),
          ),
          ListTile(
            title: const Text('즐겨찾기 개수'),
            subtitle: Text('${favorites.length}건'),
          ),
          ListTile(
            title: const Text('정책 비교함으로 이동'),
            onTap: () => context.push('/policy/compare'),
          ),
          const ListTile(
            title: Text('문의'),
            subtitle: Text('youthroad@example.com'),
          ),
        ],
      ),
    );
  }
}
