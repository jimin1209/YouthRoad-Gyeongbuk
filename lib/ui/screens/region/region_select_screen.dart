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
    const regions = <String>[
      '경북 전체',
      // 가나다 순 정렬 유지
      '경산시',
      '경주시',
      '고령군',
      '구미시',
      '군위군',
      '김천시',
      '문경시',
      '봉화군',
      '상주시',
      '성주군',
      '안동시',
      '영덕군',
      '영양군',
      '영주시',
      '영천시',
      '예천군',
      '울릉군',
      '울진군',
      '의성군',
      '청도군',
      '청송군',
      '칠곡군',
      '포항시',
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
            trailing: isSelected ? const Icon(Icons.check_circle) : const SizedBox(),
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
