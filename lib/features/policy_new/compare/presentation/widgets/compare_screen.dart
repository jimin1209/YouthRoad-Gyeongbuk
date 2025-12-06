import 'dart:math';

import 'package:flutter/material.dart';

import '../../controllers/compare_diff_service.dart';
import '../../models/compare_state.dart';
import 'compare_diff_table_widget.dart';
import 'compare_header_row_widget.dart';
import 'compare_summary_highlight.dart';

class CompareScreen extends StatefulWidget {
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
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final ScrollController _horizontalController = ScrollController();
  bool _showDiffOnly = false;

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final service = CompareDiffService();
    final labelWidth = service.labelWidth;
    final totalWidth = max(
      MediaQuery.of(context).size.width,
      labelWidth + (CompareScreen._columnWidth + 12) * state.policies.length,
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
                onPressed: widget.onRefresh,
                icon: const Icon(Icons.refresh),
              ),
              TextButton.icon(
                onPressed: widget.onClear,
                icon: const Icon(Icons.delete_outline),
                label: const Text('모두 비우기'),
              ),
            ],
          ),
        ),
        // Sticky header cards with shared horizontal scroll
        SingleChildScrollView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: totalWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CompareHeaderRowWidget(
                policies: state.policies,
                insights: state.insights,
                onRemove: widget.onRemove,
                onOpenDetail: widget.onOpenDetail,
                labelWidth: labelWidth,
                columnWidth: CompareScreen._columnWidth,
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('핵심 차이만 보기'),
                selected: _showDiffOnly,
                onSelected: (v) => setState(() => _showDiffOnly = v),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: totalWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompareSummaryHighlight(
                      insights: state.insights,
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: CompareDiffTableWidget(
                        key: ValueKey(_showDiffOnly),
                        policies: state.policies,
                        diffs: state.diffs,
                        insights: state.insights,
                        fields: service.fields,
                        labelWidth: labelWidth,
                        columnWidth: CompareScreen._columnWidth,
                        showOnlyDiffs: _showDiffOnly,
                      ),
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
