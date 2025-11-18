import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../bookmark/controller/bookmark_controller.dart';
import '../../../bookmark/data/bookmark_models.dart';
import '../../controller/policy_engagement_controller.dart';
import '../../data/models/policy.dart';

class PolicyCard extends ConsumerWidget {
  const PolicyCard({super.key, required this.policy});
  final Policy policy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkControllerProvider);
    final isBookmarked = bookmarks.maybeWhen(
      data: (items) => items.any((item) => item.policy.id == policy.id),
      orElse: () => false,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(policy.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(policy.summary),
            const SizedBox(height: 4),
            Text('지역: ${policy.regionName}', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
              tooltip: isBookmarked ? '북마크 해제' : '북마크 추가',
              onPressed: () => _handleBookmarkTap(context, ref, isBookmarked),
            ),
            if (policy.isNew)
              const Chip(
                label: Text('신규'),
                visualDensity: VisualDensity.compact,
              ),
            if (policy.endDate != null)
              Text(
                '마감: ${policy.endDate!.toLocal().toString().split(' ').first}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        onTap: () {
          ref.read(policyEngagementControllerProvider.notifier).recordClick(policy);
          context.push('/home/policy/${policy.id}');
        },
      ),
    );
  }

  Future<void> _handleBookmarkTap(
    BuildContext context,
    WidgetRef ref,
    bool isBookmarked,
  ) async {
    final controller = ref.read(bookmarkControllerProvider.notifier);
    if (isBookmarked) {
      await controller.toggle(policy);
      _showSnack(context, '북마크에서 제거했습니다.');
      return;
    }
    final folder = await _pickFolder(context) ?? BookmarkFolder.favorite;
    await controller.toggle(policy, folder: folder);
    _showSnack(context, '${folder.label} 폴더에 저장했습니다.');
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

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
