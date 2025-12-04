import 'package:flutter/material.dart';

class RegionChip extends StatelessWidget {
  const RegionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: scheme.primaryContainer,
        backgroundColor: scheme.surfaceVariant,
        labelStyle: TextStyle(
          color: selected ? scheme.primary : scheme.onSurfaceVariant,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }
}
