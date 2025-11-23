import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/providers.dart';
import '../../../navigation/route_paths.dart';
import '../../widgets/app_appbar.dart';

class RegionSelectScreen extends ConsumerWidget {
  const RegionSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regions = const [
      '경북 전체',
      '포항시',
      '구미시',
      '경산시',
      '안동시',
      '김천시',
    ];
    final selected = ref.watch(regionProvider);

    return Scaffold(
      appBar: const AppAppBar(title: '활동 지역 선택'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, i) {
              final region = regions[i];
              final isSelected = selected == region;
              return ListTile(
                title: Text(region),
                trailing:
                    isSelected ? const Icon(Icons.check_circle) : const SizedBox(),
                onTap: () {
                  ref.read(regionProvider.notifier).select(region);
                  ref.invalidate(policyListNotifierProvider);
                  ref.invalidate(policyPagingProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$region 지역이 저장되었습니다.')),
                  );
                  context.go(RoutePaths.home);
                },
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: regions.length,
      ),
    );
  }
}
