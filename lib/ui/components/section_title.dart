import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme.titleMedium;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(title, style: text),
    );
  }
}
