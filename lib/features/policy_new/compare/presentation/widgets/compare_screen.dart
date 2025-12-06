import 'dart:math';

import 'package:flutter/material.dart';

import '../../controllers/compare_diff_service.dart';
import '../../models/compare_state.dart';
import 'compare_diff_table_widget.dart';
import 'compare_header_row_widget.dart';
import 'compare_summary_highlight.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({
    super.key,
    required this.state,
    required this.onRemove,
    required this.onClear,
    required this.onOpenDetail,
    required this.onRefresh,
  });

  final CompareState state;
  final void Function(String) onRemove;
  final VoidCallback onClear;
  final void Function(String) onOpenDetail;
  final VoidCallback onRefresh;

  static const _columnWidth = 240.0;

  @override
  Widget build(BuildContext context) {
    final service = CompareDiffService();
    final labelWidth = service.labelWidth;
    final totalWidth = max(
      MediaQuery.of(context).size.width,
      labelWidth + (_columnWidth + 12) * state.policies.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Text(
                '비교 중인 정책 ${state.policies.length}개',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                tooltip: '새로고침',
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
              ),
              TextButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.delete_outline),
                label: const Text('모두 비우기'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: totalWidth,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompareHeaderRowWidget(
                      policies: state.policies,
                      insights: state.insights,
                      onRemove: onRemove,
                      onOpenDetail: onOpenDetail,
                      labelWidth: labelWidth,
                      columnWidth: _columnWidth,
                    ),
                    const SizedBox(height: 12),
                    CompareSummaryHighlight(insights: state.insights),
                    const SizedBox(height: 12),
                    CompareDiffTableWidget(
                      policies: state.policies,
                      diffs: state.diffs,
                      insights: state.insights,
                      fields: service.fields,
                      labelWidth: labelWidth,
                      columnWidth: _columnWidth,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
