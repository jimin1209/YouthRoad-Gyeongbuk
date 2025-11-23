import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers.dart';
import '../../../domain/entities/policy.dart';
import '../../../domain/repositories/policy_repository.dart';
import '../../widgets/policy_card_v2.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final policyRepository = ref.watch(policyRepositoryProvider);
    final favoriteIds = favorites.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
      ),
      body: favoriteIds.isEmpty
          ? const Center(
              child: Text('즐겨찾기한 정책이 없습니다.'),
            )
          : FutureBuilder<List<Policy>>(
              key: ValueKey(favoriteIds.join(',')),
              future: _loadPolicies(favoriteIds, policyRepository),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '데이터를 불러오지 못했습니다.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final policies = snapshot.data ?? [];

                if (policies.isEmpty) {
                  return const Center(
                    child: Text('즐겨찾기한 정책이 없습니다.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: policies.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final policy = policies[index];
                    return PolicyCardV2(policy: policy);
                  },
                );
              },
            ),
    );
  }
}

Future<List<Policy>> _loadPolicies(
  List<String> ids,
  PolicyRepository repository,
) {
  return Future.wait(ids.map(repository.fetchPolicyById));
}
