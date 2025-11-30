import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/providers.dart';
import '../../../domain/entities/policy.dart';
import '../../../domain/repositories/policy_repository.dart';
import '../../../navigation/route_paths.dart';
import '../../widgets/policy_card_v2.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final policyRepository = ref.watch(policyRepositoryInterfaceProvider);
    final compareCount = ref.watch(
      compareProvider.select((value) => value.valueOrNull?.length ?? 0),
    );
    final favoriteIds = favorites.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        actions: [
          if (compareCount > 0)
            TextButton(
              onPressed: () => context.push(RoutePaths.compare),
              child: Text('비교함 보기 ($compareCount)'),
            ),
        ],
      ),
      body: favoriteIds.isEmpty
          ? const _FavoritesEmptyView()
          : FutureBuilder<List<Policy>>(
              key: ValueKey(favoriteIds.join(',')),
              future: _loadPolicies(favoriteIds, policyRepository),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const _FavoritesEmptyView(
                    message: '데이터를 불러오지 못했습니다.',
                  );
                }

                final policies = snapshot.data ?? [];

                if (policies.isEmpty) {
                  return const _FavoritesEmptyView();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: policies.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final policy = policies[index];
                    return Dismissible(
                      key: ValueKey(policy.id),
                      direction: DismissDirection.horizontal,
                      onDismissed: (_) =>
                          ref.read(favoritesProvider.notifier).remove(policy.id),
                      background: Container(
                        color: Colors.redAccent.withOpacity(0.2),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Icon(Icons.delete_outline),
                      ),
                      secondaryBackground: Container(
                        color: Colors.redAccent.withOpacity(0.2),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Icon(Icons.delete_outline),
                      ),
                      child: PolicyCardV2(
                        policy: policy,
                        onTap: () =>
                            context.push(RoutePaths.policyDetail(policy.id)),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _FavoritesEmptyView extends StatelessWidget {
  const _FavoritesEmptyView({
    this.message = '찜한 정책이 아직 없습니다.',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
        ],
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
