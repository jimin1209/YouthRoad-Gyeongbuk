import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/providers.dart';
import '../../../domain/entities/policy.dart';
import '../../../domain/repositories/policy_repository.dart';
import '../../../features/policy_new/application/providers.dart'
    show compareRepositoryProvider, policyReminderControllerProvider;
import '../../../features/policy_new/domain/entities/policy_reminder.dart';
import '../../../features/policy_new/domain/values/reminder_time_kind.dart';
import '../../../navigation/route_paths.dart';
import '../../../ui/widgets/policy_card_v2.dart';
import '../../../features/policy_new/presentation/compare/widgets/compare_entry_bar.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final policyRepository = ref.watch(policyRepositoryInterfaceProvider);
    final compareState = ref.watch(compareRepositoryProvider);
    final compareController = ref.read(compareRepositoryProvider.notifier);
    final compareCount = compareState.ids.length;

    final favoriteIds = favorites.toList()..sort();
    final compareIds = compareState.ids;

    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        actions: [
          TextButton(
            onPressed: () => context.push(RoutePaths.compare),
            child: Text('비교 보기 ($compareCount)'),
          ),
        ],
      ),
      body: (favoriteIds.isEmpty && compareIds.isEmpty)
          ? const _FavoritesEmptyView()
          : FutureBuilder<List<Policy>>(
              key: ValueKey(favoriteIds.join(',')),
              future: _loadPolicies(favoriteIds, policyRepository),
              builder: (context, snapshot) {
                final favoritesLoaded =
                    snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData;
                final favoritePolicies = favoritesLoaded
                    ? (snapshot.data ?? <Policy>[])
                    : const <Policy>[];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle('✨ 저장된 정책'),
                      const SizedBox(height: 8),
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) ...[
                        const Center(child: CircularProgressIndicator()),
                      ] else if (favoritePolicies.isEmpty) ...[
                        const _SectionPlaceholder('찜한 정책이 없습니다.'),
                      ] else ...[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: favoritePolicies.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final policy = favoritePolicies[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PolicyCardV2(
                                  policy: policy,
                                  onTap: () => context
                                      .push(RoutePaths.policyDetail(policy.id)),
                                ),
                                _ReminderStatusText(policyId: policy.id),
                              ],
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      _SectionTitle('⚡ 비교 중인 정책'),
                      const SizedBox(height: 8),
                      _CompareListSection(
                        compareIds: compareIds,
                        policyRepository: policyRepository,
                        onOpenCompare: () => context.push(RoutePaths.compare),
                        onClear: () => compareController.clear(),
                        onRemove: compareController.remove,
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: compareCount > 0
          ? SafeArea(
              top: false,
              child: CompareEntryBar(
                itemCount: compareCount,
                onOpenCompare: () => context.push(RoutePaths.compare),
              ),
            )
          : null,
    );
  }
}

class _ReminderStatusText extends ConsumerWidget {
  const _ReminderStatusText({required this.policyId});

  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(policyReminderControllerProvider(policyId));

    return state.when(
      data: (viewState) {
        if (viewState.reminders.isEmpty) {
          return _infoText('알림 설정하기', context, highlighted: false);
        }
        final next = [...viewState.reminders]
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        final first = next.first;
        return _infoText(_label(first), context, highlighted: true);
      },
      loading: () => _infoText('알림 확인 중...', context, highlighted: false),
      error: (_, __) =>
          _infoText('알림 상태를 불러오지 못했어요', context, highlighted: false),
    );
  }

  Widget _infoText(String text, BuildContext context,
      {required bool highlighted}) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: highlighted
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
          fontWeight: highlighted ? FontWeight.w600 : FontWeight.w500,
        );
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _label(PolicyReminder reminder) {
    switch (reminder.timeKind) {
      case ReminderTimeKind.day1:
        return '마감 하루 전 예정';
      case ReminderTimeKind.day3:
        return '마감 3일 전 예정';
      case ReminderTimeKind.day7:
        return '마감 7일 전 예정';
      case ReminderTimeKind.dayOf:
        return '마감 당일 알림 예정';
    }
  }
}

class _CompareListSection extends StatelessWidget {
  const _CompareListSection({
    required this.compareIds,
    required this.policyRepository,
    required this.onOpenCompare,
    required this.onClear,
    required this.onRemove,
  });

  final List<String> compareIds;
  final PolicyRepository policyRepository;
  final VoidCallback onOpenCompare;
  final VoidCallback onClear;
  final Future<void> Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    if (compareIds.isEmpty) {
      return const _SectionPlaceholder('비교 중인 정책이 없습니다.');
    }

    return FutureBuilder<List<Policy>>(
      key: ValueKey(compareIds.join(',')),
      future: _loadPolicies(compareIds, policyRepository),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final policies = snapshot.data ?? [];
        if (policies.isEmpty) {
          return const _SectionPlaceholder('비교 중인 정책이 없습니다.');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: policies.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final policy = policies[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      policy.policyNm,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      policy.rgnSeNm ?? '지역 정보 없음',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => onRemove(policy.id),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onClear,
                    child: const Text('전체 삭제'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onOpenCompare,
                    child: const Text('비교 화면 열기'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _SectionPlaceholder extends StatelessWidget {
  const _SectionPlaceholder(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _FavoritesEmptyView extends StatelessWidget {
  const _FavoritesEmptyView({
    this.message = '찜한 정책이 없습니다.',
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
