import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/app_appbar.dart';
import '../../widgets/policy_card.dart';
import '../../../features/category/category_provider.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryPoliciesProvider);

    return Scaffold(
      appBar: const AppAppBar(title: '카테고리별 탐색'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: categories.entries
            .map(
              (entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.key,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...entry.value.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PolicyCard(policy: p),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
