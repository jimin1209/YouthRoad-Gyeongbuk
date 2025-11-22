import 'package:flutter/material.dart';

/// 상단 고정형 빠른 필터 바 (UI 상태만 처리, 로직 없음).
class QuickFilterPersistentHeader extends SliverPersistentHeaderDelegate {
  QuickFilterPersistentHeader({
    required this.onTap,
    required this.selected,
  });

  final void Function(String label) onTap;
  final String? selected;
  static const List<String> _labels = [
    '전체',
    '취업',
    '창업',
    '생활비',
    '주거',
    '교육',
    '교통',
  ];

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = _labels[index];
          return ActionChip(
            backgroundColor: selected == label ? scheme.primary.withOpacity(0.12) : null,
            label: Text(
              label,
              style: TextStyle(
                color: selected == label ? scheme.primary : scheme.onSurface,
                fontWeight: selected == label ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            onPressed: () => onTap(label),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
