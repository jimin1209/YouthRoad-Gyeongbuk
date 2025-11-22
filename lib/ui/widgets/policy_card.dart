import 'package:flutter/material.dart';

import '../../domain/entities/policy.dart';

class PolicyCard extends StatelessWidget {
  const PolicyCard({
    super.key,
    required this.policy,
    this.onTap,
  });

  final Policy policy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      surfaceTintColor: colorScheme.surfaceTint,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                policy.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                policy.summary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: policy.tags
                    .map(
                      (t) => Chip(
                        label: Text(t),
                        backgroundColor: colorScheme.surfaceContainerLow,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
