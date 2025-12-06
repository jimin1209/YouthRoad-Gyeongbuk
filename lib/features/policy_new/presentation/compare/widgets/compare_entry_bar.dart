import 'package:flutter/material.dart';

import '../../../../../ui/layout/app_floating_bar.dart';
import '../../../../../ui/components/app_button.dart';
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

    return AppFloatingBar(
      height: 56,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onOpenCompare,
        child: Row(
          children: [
            Text(
              '비교 $itemCount개',
              style: AppText.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            AppButton.text(
              label: '비교 화면 열기',
              icon: Icons.table_chart_outlined,
              onPressed: onOpenCompare,
            ),
          ],
        ),
      ),
    );
  }
}
