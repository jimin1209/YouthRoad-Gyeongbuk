import 'package:flutter/material.dart';

class CompareRemoveButton extends StatelessWidget {
  const CompareRemoveButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: '비교에서 제거',
      icon: const Icon(Icons.close),
      onPressed: onPressed,
    );
  }
}
