import 'package:flutter/material.dart';

import '../../controllers/compare_diff_service.dart';
import '../../models/compare_state.dart';
import 'compare_diff_table_widget.dart';
import 'compare_header_row_widget.dart';
import 'compare_summary_highlight.dart';

/// 비교 본문 콘텐츠를 하나로 묶어 InteractiveViewer child로 사용하기 위한 위젯.
class CompareContentView extends StatelessWidget {
  const CompareContentView({
    super.key,
    required this.state,
    required this.service,
    required this.labelWidth,
    required this.columnWidth,
    required this.onRemove,
    required this.onOpenDetail,
  });

  final CompareState state;
  final CompareDiffService service;
  final double labelWidth;
  final double columnWidth;
  final void Function(String) onRemove;
  final void Function(String) onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompareHeaderRowWidget(
          policies: state.policies,
          insights: state.insights,
          onRemove: onRemove,
          onOpenDetail: onOpenDetail,
          labelWidth: labelWidth,
          columnWidth: columnWidth,
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
          columnWidth: columnWidth,
        ),
      ],
    );
  }
}
