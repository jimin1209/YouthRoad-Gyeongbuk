import 'package:flutter/material.dart';

import '../../controllers/compare_diff_service.dart';
import '../../models/compare_state.dart';
import 'compare_diff_table_widget.dart';
import 'compare_header_row_widget.dart';
import 'compare_summary_highlight.dart';
import '../../../../../ui/components/horizontal_overflow_container.dart';

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
  final HorizontalOverflowController _overflowController =
      HorizontalOverflowController();
  final TransformationController _transformationController =
      TransformationController();
  bool _showDiffOnly = false;
  bool _isZoomed = false;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final service = CompareDiffService();
    final labelWidth = service.labelWidth;

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CompareHeaderRowWidget(
            policies: state.policies,
            insights: state.insights,
            onRemove: widget.onRemove,
            onOpenDetail: widget.onOpenDetail,
            labelWidth: labelWidth,
            columnWidth: CompareScreen._columnWidth,
            overflowController: _overflowController,
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
                label: const Text('차이만 보기'),
                selected: _showDiffOnly,
                onSelected: (v) => setState(() => _showDiffOnly = v),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scrollPhysics = _isZoomed
                  ? const NeverScrollableScrollPhysics()
                  : const ClampingScrollPhysics();
              return ClipRect(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  boundaryMargin: const EdgeInsets.all(48),
                  minScale: 1.0,
                  maxScale: 2.5,
                  panEnabled: _isZoomed,
                  onInteractionStart: (_) => _setZoomed(true),
                  onInteractionUpdate: (_) => _updateZoomState(),
                  onInteractionEnd: (_) => _updateZoomState(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: SingleChildScrollView(
                      physics: scrollPhysics,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              overflowController: _overflowController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _setZoomed(bool value) {
    if (_isZoomed != value) {
      setState(() {
        _isZoomed = value;
      });
    }
  }

  void _updateZoomState() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    final shouldEnablePan = scale > 1.01;
    _setZoomed(shouldEnablePan);
  }
}
