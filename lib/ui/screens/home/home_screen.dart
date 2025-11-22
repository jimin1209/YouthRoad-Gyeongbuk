import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/policy_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policies = ref.watch(policyListNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(title: '청년 정책 추천'),
      body: policies.when(
        data: (list) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (_, i) => PolicyCard(policy: list[i]),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: list.length,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Text('불러오기에 실패했습니다: $e'),
        ),
      ),
    );
  }
}
