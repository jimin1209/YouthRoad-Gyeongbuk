import 'package:flutter/material.dart';

class DebugButton extends StatelessWidget {
  const DebugButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: const Color(0xFF4D8AF0),
        elevation: 2,
        onPressed: onPressed,
        child: const Icon(
          Icons.bug_report,
          color: Colors.white,
        ),
      ),
    );
  }
}
