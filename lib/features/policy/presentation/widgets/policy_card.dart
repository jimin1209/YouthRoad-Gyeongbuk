import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../bookmark/controller/bookmark_controller.dart';
import '../../../bookmark/data/bookmark_models.dart';
import '../../controller/policy_engagement_controller.dart';
import '../../data/models/policy.dart';

class PolicyCard extends ConsumerWidget {
  const PolicyCard({
    super.key,
    required this.policy,
    this.margin,
  });
  final Policy policy;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkControllerProvider);
    final isBookmarked = bookmarks.maybeWhen(
      data: (items) => items.any((item) => item.policy.id == policy.id),
      orElse: () => false,
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dday = _dDayText(policy.endDate);

    final padding = margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final isClosed = policy.endDate != null && policy.endDate!.isBefore(DateTime.now());

    return Padding(
      padding: padding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: () {
              ref.read(policyEngagementControllerProvider.notifier).recordClick(policy);
              context.push('/home/policy/${policy.id}');
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (dday != null)
                        _Badge(
                          label: dday,
                          color: isClosed
                              ? colorScheme.errorContainer
                              : colorScheme.primaryContainer,
                          textColor:
                              isClosed ? colorScheme.onErrorContainer : colorScheme.onPrimaryContainer,
                        ),
                      if (policy.isNew) ...[
                        if (dday != null) const SizedBox(width: 8),
                        _Badge(
                          label: '신규',
                          color: colorScheme.secondaryContainer,
                          textColor: colorScheme.onSecondaryContainer,
                        ),
                      ],
                      const Spacer(),
                      IconButton(
                        icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                        color: isBookmarked ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        tooltip: isBookmarked ? '북마크 해제' : '북마크 추가',
                        onPressed: () => _handleBookmarkTap(context, ref, isBookmarked),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    policy.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    policy.summary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  if (policy.categories.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          policy.categories.take(3).map((category) => Chip(label: Text(category))).toList(),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.place_rounded, size: 18, color: colorScheme.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          policy.regionName,
                          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (policy.institutionName?.isNotEmpty ?? false)
                        Flexible(
                          child: Text(
                            policy.institutionName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (policy.endDate != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.event_available_outlined, size: 18, color: colorScheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          policy.endDate!.toLocal().toString().split(' ').first,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
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

  String? _dDayText(DateTime? endDate) {
    if (endDate == null) {
      return null;
    }
    final now = DateTime.now();
    final days = endDate.difference(now).inDays;
    if (days < 0) {
      return '마감';
    }
    if (days == 0) {
      return 'D-Day';
    }
    return 'D-${days + 1}';
  }
}

class PolicyCardSkeleton extends StatelessWidget {
  const PolicyCardSkeleton({super.key, this.margin});

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final padding = margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    return Padding(
      padding: padding,
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SkeletonBox(width: 100, height: 18, color: scheme.surfaceVariant),
            const SizedBox(height: 16),
            _SkeletonBox(width: double.infinity, height: 20, color: scheme.surfaceVariant),
            const SizedBox(height: 10),
            _SkeletonBox(width: double.infinity, height: 14, color: scheme.surfaceVariant),
            const Spacer(),
            _SkeletonBox(width: 140, height: 16, color: scheme.surfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width,
        height: height,
        color: color.withOpacity(0.6),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, required this.textColor});

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: textColor, fontWeight: FontWeight.w600),
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
