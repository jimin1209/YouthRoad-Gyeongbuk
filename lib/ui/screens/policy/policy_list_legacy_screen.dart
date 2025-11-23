import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/notifiers/policy_list_notifier.dart';
import '../../../application/providers.dart';
import '../../widgets/global_error_view.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/policy_card.dart';

class PolicyListLegacyScreen extends ConsumerWidget {
  const PolicyListLegacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policies = ref.watch(policyListNotifierProvider);
    final notifier = ref.read(policyListNotifierProvider.notifier);
    return Scaffold(
      appBar: const AppAppBar(title: '레거시 정책 목록'),
      body: policies.when(
        data: (list) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (_, i) => PolicyCard(policy: list[i]),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: list.length,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => GlobalErrorView(
          message: PolicyListNotifier.errorMessage,
          onRetry: notifier.refreshPolicies,
        ),
      ),
    );
  }
}
