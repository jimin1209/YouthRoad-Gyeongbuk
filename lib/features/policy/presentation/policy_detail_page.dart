import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../bookmark/controller/bookmark_controller.dart';
import '../controller/policy_detail_controller.dart';
import '../controller/policy_list_controller.dart';

class PolicyDetailPage extends ConsumerWidget {
  const PolicyDetailPage({super.key, required this.policyId});
  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policyAsync = ref.watch(policyDetailControllerProvider(policyId));
    return Scaffold(
      appBar: AppBar(title: const Text('정책 상세')),
      body: policyAsync.when(
        data: (policy) {
          final bookmarkController = ref.read(bookmarkControllerProvider.notifier);
          final isBookmarked = ref.watch(bookmarkControllerProvider).maybeWhen(
                data: (items) => items.any((item) => item.id == policy.id),
                orElse: () => false,
              );
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(policy.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(policy.summary),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Chip(label: Text(policy.regionName)),
                    ...policy.categories.map((category) => Chip(label: Text(category))),
                  ],
                ),
                const Divider(),
                Text('지원 대상: ${policy.minAge}~${policy.maxAge}세'),
                if (policy.targetGroups.isNotEmpty)
                  Text('대상 그룹: ${policy.targetGroups.join(', ')}'),
                const SizedBox(height: 12),
                Text('지원 내용', style: Theme.of(context).textTheme.titleMedium),
                Text(policy.supportDetail),
                const SizedBox(height: 12),
                Text('지원 형태: ${policy.supportType}'),
                const SizedBox(height: 12),
                Text('신청 방법: ${policy.applicationMethod}'),
                TextButton(
                  onPressed: policy.applicationUrl.isEmpty
                      ? null
                      : () => launchUrlString(policy.applicationUrl, mode: LaunchMode.externalApplication),
                  child: const Text('신청 페이지 열기'),
                ),
                const SizedBox(height: 12),
                Text('문의처: ${policy.contact}'),
                if (policy.endDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('마감일: ${policy.endDate!.toLocal().toString().split(' ').first}'),
                  ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    await bookmarkController.toggle(policy);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isBookmarked ? '북마크에서 제거되었습니다.' : '북마크에 추가되었습니다.'),
                      ),
                    );
                  },
                  icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                  label: Text(isBookmarked ? '북마크 해제' : '북마크 추가'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(filterStateProvider.notifier).state =
                        ref.read(filterStateProvider.notifier).state.copyWith(region: policy.regionCode);
                    context.push(
                      '/home/unity-map',
                      extra: {
                        'regionCode': policy.regionCode,
                        'regionName': policy.regionName,
                      },
                    );
                  },
                  icon: const Icon(Icons.map),
                  label: const Text('지도에서 위치 보기'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('불러오지 못했습니다: $e')),
      ),
    );
  }
}
