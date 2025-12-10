import 'package:flutter/material.dart';

import '../../policy_new/data/mappers/youth_center_mapper.dart';

class CenterCardItem extends StatelessWidget {
  const CenterCardItem({
    super.key,
    required this.center,
    this.onTap,
  });

  final CenterMarkerPoint center;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 250,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.primary.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  center.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  center.regionLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurface.withOpacity(0.7),
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  center.fullAddress,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurface.withOpacity(0.8),
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (center.phone != null && center.phone!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 16,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          center.phone!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colors.primary,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (center.url != null && center.url!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.link,
                        size: 16,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          center.url!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
