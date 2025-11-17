import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/policy_list_controller.dart';
import 'widgets/policy_card.dart';

class PolicyListPage extends ConsumerWidget {
  const PolicyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policiesAsync = ref.watch(policyListControllerProvider);
    return policiesAsync.when(
      data: (policies) => ListView.builder(
        itemCount: policies.length,
        itemBuilder: (context, index) {
          final policy = policies[index];
          return PolicyCard(policy: policy);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('불러오지 못했습니다: $e')),
    );
  }
}
