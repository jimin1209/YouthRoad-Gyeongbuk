import 'package:flutter/material.dart';
import 'package:youth_road_app/theme/app_theme.dart';

class PolicyEmptyState extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  const PolicyEmptyState({
    super.key,
    required this.message,
    this.buttonText,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final pol = Theme.of(context).extension<PolicyTheme>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: pol.emptyStateIconColor,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: pol.emptyStateTextColor,
                  ),
            ),
            if (buttonText != null) ...[
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onButtonTap,
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
