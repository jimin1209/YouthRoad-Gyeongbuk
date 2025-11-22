import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/formatters.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/youth_app_bar.dart';
import '../../data/model/policy_models.dart';
import 'local/favorite_policies_notifier.dart';
import 'local/local_policy_store.dart';
import 'local/recent_policies_notifier.dart';

class PolicyDetailScreen extends ConsumerWidget {
  const PolicyDetailScreen({
    super.key,
    required this.id,
    this.policy,
  });

  final String id;
  final PolicyItem? policy;

  Future<PolicyItem?> _resolvePolicy(WidgetRef ref) async {
    if (policy != null) return policy;
    final store = ref.read(localPolicyStoreProvider);
    final recents = await store.loadRecent();
    try {
      return recents.firstWhere((element) => element.no == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritePoliciesProvider).maybeWhen(
          data: (data) => data,
          orElse: () => <String>[],
        );

    return FutureBuilder<PolicyItem?>(
      future: _resolvePolicy(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: LoadingView(fullscreen: true)),
          );
        }
        final PolicyItem? item = snapshot.data;
        if (item == null) {
          return const Scaffold(
            body: Center(child: Text('정책 정보를 찾을 수 없습니다.')),
          );
        }
        final bool isFavorite = favoriteIds.contains(item.no ?? '');
        ref.read(recentPoliciesProvider.notifier).addRecent(item);

        return Scaffold(
          appBar: YouthAppBar(
            title: item.policyNm ?? '정책 상세',
            onBack: () => context.pop(),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Theme.of(context).colorScheme.primary : null,
                ),
                onPressed: () => ref.read(favoritePoliciesProvider.notifier).toggle(item.no ?? ''),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.policyNm ?? '', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(item.policyTypeNm ?? '유형 없음')),
                    Chip(label: Text(item.rgnSeNm ?? '지역 없음')),
                  ],
                ),
                const SizedBox(height: 12),
                _infoRow('주관기관', item.sprvsnInstNm),
                _infoRow('운영기관', item.operInstNm),
                _infoRow('운영 기간', formatDateRange(item.policyBgngYmd, item.policyEndYmd)),
                _infoRow('신청 가능 여부', item.aplyPsbltyYn == 'Y' ? '신청 가능' : '신청 불가'),
                _infoRow('온라인 신청 여부', item.aplyYn ?? '정보 없음'),
                const SizedBox(height: 12),
                Text('내용', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(item.policyCn ?? '내용이 없습니다.'),
                const SizedBox(height: 12),
                _infoRow('문의처', item.policyEnq),
                if ((item.dtlLinkUrl ?? '').isNotEmpty) ...[
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.push('/policy/detail/${item.no ?? ''}/web', extra: item.dtlLinkUrl),
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('자세히 보기'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value ?? '정보 없음'),
          ),
        ],
      ),
    );
  }
}
