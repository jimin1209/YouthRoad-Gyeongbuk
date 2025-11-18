import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../bookmark/controller/bookmark_controller.dart';
import '../../bookmark/data/bookmark_models.dart';
import '../controller/policy_detail_controller.dart';
import '../controller/policy_list_controller.dart';
import '../controller/policy_engagement_controller.dart';
import 'widgets/policy_card.dart';

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
          ref.read(policyEngagementControllerProvider.notifier).recordView(policy);
          final bookmarkController = ref.read(bookmarkControllerProvider.notifier);
          final bookmarks = ref.watch(bookmarkControllerProvider);
          final isBookmarked = bookmarks.maybeWhen(
                data: (items) => items.any((item) => item.policy.id == policy.id),
                orElse: () => false,
              );
          final related = ref.watch(relatedPoliciesProvider(policy));
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
                TextButton.icon(
                  onPressed: policy.applicationUrl.isEmpty
                      ? null
                      : () => _sharePolicy(context, policy.applicationUrl),
                  icon: const Icon(Icons.share),
                  label: const Text('링크 공유'),
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
                    if (isBookmarked) {
                      await bookmarkController.toggle(policy);
                      _showSnack(context, '북마크에서 제거되었습니다.');
                    } else {
                      final folder = await _pickFolder(context) ?? BookmarkFolder.favorite;
                      await bookmarkController.toggle(policy, folder: folder);
                      _showSnack(context, '${folder.label} 폴더에 추가되었습니다.');
                    }
                  },
                  icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                  label: Text(isBookmarked ? '북마크 해제' : '북마크 추가'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(policyFilterUseProfileProvider.notifier)
                        .state = false;
                    ref.read(policyFilterStateProvider.notifier).state =
                        ref
                            .read(policyFilterStateProvider.notifier)
                            .state
                            .copyWith(region: policy.regionCode);
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
                const SizedBox(height: 24),
                Text('연관 정책 추천', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SizedBox(
                  height: 250,
                  child: related.when(
                    data: (items) => items.isEmpty
                        ? const Center(child: Text('연관 정책이 없습니다.'))
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => SizedBox(
                              width: 320,
                              child: PolicyCard(policy: items[index]),
                            ),
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemCount: items.length,
                          ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('연관 정책을 불러오지 못했습니다: $e')),
                  ),
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

  Future<BookmarkFolder?> _pickFolder(BuildContext context) {
    return showModalBottomSheet<BookmarkFolder>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: BookmarkFolder.values
                .map(
                  (folder) => ListTile(
                    title: Text(folder.label),
                    onTap: () => Navigator.of(context).pop(folder),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _sharePolicy(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    _showSnack(context, '링크가 복사되었습니다. 원하는 채팅 앱에 붙여넣어 공유하세요.');
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
