import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/policy.dart';
import '../../../application/controllers/policy_action_controller.dart';
import '../../../application/providers.dart';
import '../../../../../ui/theme/app_spacing.dart';
import '../../../../../ui/theme/app_text.dart';

class PolicyActionBar extends ConsumerWidget {
  const PolicyActionBar({super.key, required this.policy});

  final Policy policy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(policyActionControllerProvider(policy.id));
    final controller =
        ref.read(policyActionControllerProvider(policy.id).notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 0,
            maxWidth: maxWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    state.errorMessage!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ),

              Row(
                children: [
                  Expanded(
                    child: PolicyActionButton(
                      icon: state.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      label: '찜하기',
                      active: state.isFavorite,
                      onPressed: state.isProcessing
                          ? null
                          : () async => controller.toggleFavorite(policy),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: PolicyActionButton(
                      icon: state.isCompared
                          ? Icons.compare_arrows
                          : Icons.compare_arrows_outlined,
                      label: '비교함',
                      active: state.isCompared,
                      onPressed: state.isProcessing
                          ? null
                          : () async => controller.toggleCompare(policy),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              PolicyActionButton(
                icon: Icons.open_in_new,
                label: '신청 페이지 열기',
                description: '정책 안내 페이지로 이동',
                variant: PolicyActionButtonVariant.primary,
                onPressed: state.isProcessing
                    ? null
                    : () async {
                        final opened = await controller.openPolicyLink(policy);
                        if (!opened && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('신청 페이지를 열지 못했습니다.'),
                            ),
                          );
                        }
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}

enum PolicyActionButtonVariant { tonal, primary }

class PolicyActionButton extends StatelessWidget {
  const PolicyActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.description,
    this.onPressed,
    this.active = false,
    this.variant = PolicyActionButtonVariant.tonal,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String? description;
  final VoidCallback? onPressed;
  final bool active;
  final PolicyActionButtonVariant variant;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final enabled = onPressed != null;

    Color resolveBackground() {
      if (!enabled) return colors.surfaceVariant.withOpacity(0.6);
      if (variant == PolicyActionButtonVariant.primary) return colors.primary;
      if (active) return colors.primaryContainer;
      return colors.surfaceVariant;
    }

    Color resolveForeground() {
      if (variant == PolicyActionButtonVariant.primary) {
        return enabled ? colors.onPrimary : colors.onSurface.withOpacity(0.4);
      }
      if (!enabled) return colors.onSurface.withOpacity(0.38);
      if (active) return colors.onPrimaryContainer;
      return colors.onSurface;
    }

    final background = resolveBackground();
    final foreground = resolveForeground();

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: variant == PolicyActionButtonVariant.tonal && !active
              ? BorderSide(color: colors.outlineVariant)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: foreground),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: description == null
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.textTheme.labelLarge?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.textTheme.bodySmall?.copyWith(
                            color: foreground.withOpacity(0.82),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
