import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/controllers/ui_reaction_controller.dart';
import '../../application/filters/policy_filter_ui_state.dart';
import '../../domain/values/policy_feed_type.dart';
import '../../domain/values/policy_sort.dart';

class PolicySortBottomSheet extends ConsumerWidget {
  const PolicySortBottomSheet({
    super.key,
    required this.feedType,
  });

  final PolicyFeedType feedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(policyFilterUiStateProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '정렬 기준',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...PolicySortOption.values.map(
              (option) => RadioListTile<PolicySortOption>(
                title: Text(_label(option)),
                value: option,
                groupValue: ui.sort,
                onChanged: (value) {
                  if (value == null) return;
                  ref.read(policyFilterUiStateProvider.notifier).setSort(value);
                  ref
                      .read(uiReactionControllerProvider(feedType).notifier)
                      .markFilterConfirmed('${_label(value)} 정렬을 적용했어요.');
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _label(PolicySortOption option) {
    switch (option) {
      case PolicySortOption.latest:
        return '최신순';
      case PolicySortOption.deadline:
        return '마감 임박';
      case PolicySortOption.popularity:
        return '인기순';
      case PolicySortOption.recommendation:
        return '추천순';
    }
  }
}
