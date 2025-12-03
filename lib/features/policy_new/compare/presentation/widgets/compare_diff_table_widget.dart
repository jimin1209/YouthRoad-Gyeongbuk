import 'package:flutter/material.dart';

import '../../controllers/compare_diff_service.dart';
import '../../../domain/entities/policy.dart';

class CompareDiffTableWidget extends StatelessWidget {
  const CompareDiffTableWidget({
    super.key,
    required this.policies,
    required this.diffs,
    required this.fields,
    required this.labelWidth,
    required this.columnWidth,
  });

  final List<Policy> policies;
  final Map<String, bool> diffs;
  final List<CompareFieldDefinition> fields;
  final double labelWidth;
  final double columnWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: fields
          .map(
            (field) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: labelWidth,
                    child: Text(
                      field.label,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  ...policies.map(
                    (p) {
                      final isDiff = diffs[field.key] ?? false;
                      final value = field.valueBuilder(p);
                      return Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Container(
                          width: columnWidth,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDiff
                                ? Colors.lightBlueAccent.withOpacity(0.08)
                                : Colors.grey.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            value.isNotEmpty ? value : '-',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
