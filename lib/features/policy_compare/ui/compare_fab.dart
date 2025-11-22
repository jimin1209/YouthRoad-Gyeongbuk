import 'package:flutter/material.dart';

/// 비교함 상태를 알리는 FloatingActionButton (UI-only).
class CompareFab extends StatelessWidget {
  const CompareFab({super.key, this.count = 0, this.onTap});

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      icon: const Icon(Icons.compare_arrows),
      label: Text(count > 0 ? '비교함 ($count)' : '비교함'),
    );
  }
}
