import 'package:flutter/material.dart';

import '../../../../../ui/layout/app_floating_bar.dart';
import '../../../../../ui/theme/app_text.dart';

class CompareEntryBar extends StatelessWidget {
  const CompareEntryBar({
    super.key,
    required this.itemCount,
    required this.onOpenCompare,
  });

  final int itemCount;
  final VoidCallback onOpenCompare;

  @override
  Widget build(BuildContext context) {
    if (itemCount < 1) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final buttonStyle = FilledButton.styleFrom(
      minimumSize: const Size(0, 44),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      textStyle: AppText.textTheme.labelMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: colorScheme.primary.withOpacity(0.14),
      ),
      child: AppFloatingBar(
        height: 56,
        child: AnimatedScale(
          scale: 1.0 + (itemCount > 0 ? 0.05 : 0.0),
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '비교 $itemCount개',
                  style: AppText.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: onOpenCompare,
                icon: const Icon(Icons.table_chart_outlined, size: 18),
                label: const Text('비교 화면 열기'),
                style: buttonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
