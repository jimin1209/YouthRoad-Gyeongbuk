import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/youth_app_bar.dart';
import 'region_model.dart';
import 'region_provider.dart';

class RegionSelectScreen extends ConsumerWidget {
  const RegionSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Region> regions = ref.watch(regionListProvider);
    final Region? selected = ref.watch(selectedRegionProvider);

    return Scaffold(
      appBar: YouthAppBar(
        title: '어디에 살고 계신가요?',
        onBack: () => context.pop(),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: regions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final Region region = regions[index];
          final bool isSelected = selected?.code == region.code;
          return ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            tileColor: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.08) : Colors.white,
            title: Text(region.name),
            trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blueAccent) : null,
            onTap: () async {
              await ref.read(selectedRegionProvider.notifier).selectRegion(region);
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/policy/list');
              }
            },
          );
        },
      ),
    );
  }
}
