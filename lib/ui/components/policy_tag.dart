import 'package:flutter/material.dart';
import 'package:youth_road_app/theme/app_theme.dart';

class PolicyTag extends StatelessWidget {
  final String label;

  const PolicyTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final policyTheme = Theme.of(context).extension<PolicyTheme>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(policyTheme.policyTagRadius),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
