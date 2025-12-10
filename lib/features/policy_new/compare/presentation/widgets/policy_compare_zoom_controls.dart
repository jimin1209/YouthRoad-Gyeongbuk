import 'package:flutter/material.dart';

import '../../../../../ui/theme/app_colors.dart';
import '../../../../../ui/theme/app_spacing.dart';
import '../../../../../ui/theme/app_text.dart';

class PolicyCompareZoomControls extends StatelessWidget {
  const PolicyCompareZoomControls({
    super.key,
    required this.currentScale,
    required this.minScale,
    required this.maxScale,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  final double currentScale;
  final double minScale;
  final double maxScale;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final scalePercent = (currentScale * 100).round();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: '축소',
              icon: const Icon(Icons.remove),
              onPressed: currentScale <= minScale ? null : onZoomOut,
            ),
            InkWell(
              onTap: onReset,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(
                  '$scalePercent%',
                  style: AppText.textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: '확대',
              icon: const Icon(Icons.add),
              onPressed: currentScale >= maxScale ? null : onZoomIn,
            ),
          ],
        ),
      ),
    );
  }
}
