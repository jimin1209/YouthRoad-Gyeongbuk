import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/filters/policy_filter_ui_state.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_region.dart';

class PolicyFilterBottomSheet extends ConsumerWidget {
  const PolicyFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(policyFilterUiStateProvider);
    final notifier = ref.read(policyFilterUiStateProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '필터',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: notifier.resetAll,
                    child: const Text('초기화'),
                  )
                ],
              ),
              const SizedBox(height: 12),
              const Text('지역'),
              Wrap(
                spacing: 8,
                children: PolicyRegion.values
                    .map(
                      (region) => ChoiceChip(
                        label: Text(region.name),
                        selected: ui.region == region,
                        onSelected: (_) => notifier.setRegion(region),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              const Text('카테고리'),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('전체'),
                    selected: ui.category == null,
                    onSelected: (_) => notifier.setCategory(null),
                  ),
                  ...PolicyCategory.values.map(
                    (category) => ChoiceChip(
                      label: Text(category.name),
                      selected: ui.category == category,
                      onSelected: (_) => notifier.setCategory(category),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('온라인만 보기'),
                value: ui.showOnlyOnline,
                onChanged: (_) => notifier.toggleOnlineOnly(),
              ),
              SwitchListTile(
                title: const Text('모집중만 보기'),
                value: ui.showOnlyOngoing,
                onChanged: (_) => notifier.toggleOngoingOnly(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
