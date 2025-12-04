import 'package:flutter/material.dart';
import 'package:youth_road_app/theme/app_theme.dart';

import 'policy_tag.dart';

class PolicyCard extends StatelessWidget {
  final String title;
  final String summary;
  final List<String> tags;
  final String period;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onShareTap;

  const PolicyCard({
    super.key,
    required this.title,
    required this.summary,
    required this.tags,
    required this.period,
    this.onTap,
    this.onFavoriteTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final policyTheme = Theme.of(context).extension<PolicyTheme>()!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(policyTheme.policyCardRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(policyTheme.policyCardRadius),
        onTap: onTap,
        child: Padding(
          padding: policyTheme.policyCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 아이콘 영역
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: onFavoriteTap,
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        onPressed: onShareTap,
                      ),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 6),

              Text(
                summary,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 10),

              // 태그 영역
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: tags.map((e) => PolicyTag(label: e)).toList(),
              ),

              const SizedBox(height: 12),

              Text(
                period,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
