import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../controllers/compare_diff_service.dart';
import '../../models/compare_state.dart';
import 'compare_diff_table_widget.dart';
import 'compare_header_row_widget.dart';
import 'compare_summary_highlight.dart';
import '../../../../../ui/components/horizontal_overflow_container.dart';
import '../../../../../ui/theme/app_colors.dart';
import '../../../../../ui/theme/app_spacing.dart';
import '../../../../../ui/theme/app_text.dart';

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
  final GlobalKey _viewerKey = GlobalKey();
  static const double _minScale = 0.8;
  static const double _maxScale = 2.5;
  static const double _zoomStep = 0.1;
  double _currentScale = 1.0;
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
    const headerMinHeight = 180.0;
    const zoomableMinHeight = 320.0;

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
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: headerMinHeight),
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
        ),
        const Divider(height: 1),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double viewportHeight = constraints.maxHeight;
              final double minZoomHeight =
                  math.max(zoomableMinHeight, viewportHeight * 0.6);

              return _ZoomableCompareContent(
                summary: CompareSummaryHighlight(
                  insights: state.insights,
                ),
                table: CompareDiffTableWidget(
                  policies: state.policies,
                  diffs: state.diffs,
                  insights: state.insights,
                  fields: service.fields,
                  labelWidth: labelWidth,
                  columnWidth: CompareScreen._columnWidth,
                  overflowController: _overflowController,
                ),
                isZoomed: _isZoomed,
                minHeight: minZoomHeight,
                minScale: _minScale,
                maxScale: _maxScale,
                currentScale: _currentScale,
                onZoomStateChanged: _setZoomed,
                onUpdateZoom: _syncZoomState,
                onInteractionEnd: _syncZoomState,
                onZoomIn: _zoomIn,
                onZoomOut: _zoomOut,
                onZoomReset: _resetZoom,
                viewerKey: _viewerKey,
                transformationController: _transformationController,
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

  void _syncZoomState() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    final clampedScale = scale.clamp(_minScale, _maxScale);
    final shouldEnablePan = clampedScale > 1.01;
    if ((_currentScale - clampedScale).abs() > 0.005 ||
        _isZoomed != shouldEnablePan) {
      setState(() {
        _currentScale = clampedScale;
        _isZoomed = shouldEnablePan;
      });
    }
  }

  void _resetZoom() {
    setState(() {
      _currentScale = 1.0;
      _isZoomed = false;
      _transformationController.value = Matrix4.identity();
    });
  }

  void _zoomIn() {
    _setScale(_currentScale + _zoomStep);
  }

  void _zoomOut() {
    _setScale(_currentScale - _zoomStep);
  }

  void _setScale(double scale) {
    final clamped = scale.clamp(_minScale, _maxScale);
    final matrix = _transformationController.value.clone();
    final current = matrix.getMaxScaleOnAxis();
    final baseMatrix = current > 0 ? matrix : Matrix4.identity();
    final factor = clamped / (current > 0 ? current : 1.0);
    final renderBox = _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    final focalPoint = renderBox?.size.center(Offset.zero);
    final updatedMatrix = focalPoint != null
        ? (Matrix4.identity()
              ..translate(focalPoint.dx, focalPoint.dy)
              ..scale(factor)
              ..translate(-focalPoint.dx, -focalPoint.dy))
            .multiplied(baseMatrix)
        : (baseMatrix.clone()..scale(factor));
    setState(() {
      _currentScale = clamped;
      _isZoomed = clamped > 1.01;
      _transformationController.value = updatedMatrix;
    });
  }
}

class _ZoomableCompareContent extends StatelessWidget {
  const _ZoomableCompareContent({
    required this.summary,
    required this.table,
    required this.isZoomed,
    required this.minHeight,
    required this.minScale,
    required this.maxScale,
    required this.currentScale,
    required this.onZoomStateChanged,
    required this.onUpdateZoom,
    required this.onInteractionEnd,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onZoomReset,
    required this.viewerKey,
    required this.transformationController,
  });

  final Widget summary;
  final Widget table;
  final bool isZoomed;
  final double minHeight;
  final double minScale;
  final double maxScale;
  final double currentScale;
  final void Function(bool) onZoomStateChanged;
  final VoidCallback onUpdateZoom;
  final VoidCallback onInteractionEnd;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onZoomReset;
  final GlobalKey viewerKey;
  final TransformationController transformationController;

  @override
  Widget build(BuildContext context) {
    final scrollPhysics = isZoomed
        ? const NeverScrollableScrollPhysics()
        : const ClampingScrollPhysics();

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: ClipRect(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onDoubleTap: onZoomReset,
                child: InteractiveViewer(
                  key: viewerKey,
                  transformationController: transformationController,
                  boundaryMargin: const EdgeInsets.all(48),
                  minScale: minScale,
                  maxScale: maxScale,
                  panEnabled: isZoomed,
                  onInteractionStart: (_) => onZoomStateChanged(true),
                  onInteractionUpdate: (_) => onUpdateZoom(),
                  onInteractionEnd: (_) => onInteractionEnd(),
                  child: SingleChildScrollView(
                    physics: scrollPhysics,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        summary,
                        const SizedBox(height: AppSpacing.md),
                        table,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: AppSpacing.lg,
            top: AppSpacing.sm,
            child: _ZoomControlBar(
              currentScale: currentScale,
              minScale: minScale,
              maxScale: maxScale,
              onZoomIn: onZoomIn,
              onZoomOut: onZoomOut,
              onReset: onZoomReset,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomControlBar extends StatelessWidget {
  const _ZoomControlBar({
    required this.currentScale,
    required this.minScale,
    required this.maxScale,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  final double currentScale;
  final double minScale;
  final double maxScale;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final scalePercent = (currentScale * 100).round();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: '축소',
              icon: const Icon(Icons.remove),
              onPressed: currentScale <= minScale ? null : onZoomOut,
            ),
            InkWell(
              onTap: onReset,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(
                  '$scalePercent%',
                  style: AppText.textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: '확대',
              icon: const Icon(Icons.add),
              onPressed: currentScale >= maxScale ? null : onZoomIn,
            ),
          ],
        ),
      ),
    );
  }
}
