import 'package:flutter/material.dart';

import '../../../../ui/components/policy_skeleton_card.dart';

class PolicyListSkeleton extends StatelessWidget {
  const PolicyListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemBuilder: (_, __) => const PolicySkeletonCard(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: 5,
    );
  }
}
