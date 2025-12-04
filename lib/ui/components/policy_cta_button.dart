import 'package:flutter/material.dart';

class PolicyCtaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const PolicyCtaButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(text),
    );
  }
}
