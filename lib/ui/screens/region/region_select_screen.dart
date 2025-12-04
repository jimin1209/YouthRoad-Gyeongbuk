import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/notifiers/region_notifier.dart';
import '../../../features/policy_new/presentation/filters/widgets/region_selector_section.dart';
import '../../../application/providers.dart' show policyListNotifierProvider;
import '../../../navigation/route_paths.dart';
import '../../widgets/app_appbar.dart';

class RegionSelectScreen extends ConsumerWidget {
  const RegionSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(regionProvider.notifier);

    return Scaffold(
      appBar: AppAppBar(
        title: '활동 지역 선택',
        actions: [
          TextButton(
            onPressed: () {
              notifier.applyToFilter();
              ref.invalidate(policyListNotifierProvider);
              context.go(RoutePaths.home);
            },
            child: const Text('완료'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const RegionSelectorSection(),
            const SizedBox(height: 12),
            Text(
              '현재 선택: ${notifier.summary}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                notifier.applyToFilter();
                ref.invalidate(policyListNotifierProvider);
                context.go(RoutePaths.home);
              },
              child: const Text('선택 적용 후 홈으로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
