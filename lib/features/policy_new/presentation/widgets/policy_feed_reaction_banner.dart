import 'package:flutter/material.dart';

import '../../application/controllers/ui_reaction_controller.dart';

class PolicyFeedReactionBanner extends StatelessWidget {
  const PolicyFeedReactionBanner({
    super.key,
    required this.state,
    required this.onRetry,
  });

  final UIReactionState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isVisible = state.isActive;
    final colorScheme = Theme.of(context).colorScheme;
    final background = switch (state.phase) {
      UIReactionPhase.failure => colorScheme.errorContainer,
      UIReactionPhase.confirmed => colorScheme.primaryContainer,
      UIReactionPhase.success => colorScheme.primaryContainer,
      UIReactionPhase.unchanged => colorScheme.surfaceVariant,
      _ => colorScheme.surfaceVariant,
    };

    final textColor = switch (state.phase) {
      UIReactionPhase.failure => colorScheme.onErrorContainer,
      UIReactionPhase.confirmed => colorScheme.onPrimaryContainer,
      UIReactionPhase.success => colorScheme.onPrimaryContainer,
      UIReactionPhase.unchanged => colorScheme.onSurfaceVariant,
      _ => colorScheme.onSurfaceVariant,
    };

    final icon = switch (state.phase) {
      UIReactionPhase.failure => Icons.warning_amber_rounded,
      UIReactionPhase.success => Icons.check_circle,
      UIReactionPhase.confirmed => Icons.play_arrow_rounded,
      UIReactionPhase.unchanged => Icons.info_outline,
      _ => Icons.autorenew,
    };

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 200),
      crossFadeState:
          isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(12),
          color: background,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: textColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (state.phase == UIReactionPhase.failure)
                  TextButton(
                    onPressed: onRetry,
                    child: const Text('재시도'),
                  ),
              ],
            ),
          ),
        ),
      ),
      secondChild: const SizedBox(height: 12),
    );
  }
}
