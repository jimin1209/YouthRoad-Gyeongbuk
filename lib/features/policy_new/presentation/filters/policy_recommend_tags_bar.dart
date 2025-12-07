import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../application/filters/policy_filter_ui_state.dart';

class PolicyRecommendTagsBar extends ConsumerWidget {
  const PolicyRecommendTagsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(globalFilterProvider);
    final notifier = ref.read(globalFilterProvider.notifier);
    final profileTags = ref.watch(userProfileProvider).recommendTags;
    final tags = ui.tags.isNotEmpty
        ? ui.tags
        : (profileTags.isNotEmpty ? profileTags : _defaultTags);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: tags
            .map(
              (tag) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(tag),
                  selected: ui.tags.contains(tag),
                  onSelected: (selected) {
                    final updated = [...ui.tags];
                    if (selected && !updated.contains(tag)) {
                      updated.add(tag);
                    } else if (!selected) {
                      updated.remove(tag);
                    }
                    notifier.setTags(updated);
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<String> get _defaultTags => const ['청년 취업', '창업', '주거', '교육'];
}
