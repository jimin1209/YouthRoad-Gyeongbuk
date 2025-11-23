import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';

class CompareBadge extends ConsumerWidget {
  const CompareBadge({
    super.key,
    required this.child,
    this.offset = const Offset(10, -6),
  });

  final Widget child;
  final Offset offset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(
      compareProvider.select((value) => value.valueOrNull?.length ?? 0),
    );

    if (count == 0) return child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: offset.dx,
          top: offset.dy,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
