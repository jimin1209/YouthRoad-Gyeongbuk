import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:youth_road_app/features/policy_new/compare/controllers/compare_diff_service.dart';
import 'package:youth_road_app/features/policy_new/compare/models/compare_state.dart';
import 'package:youth_road_app/features/policy_new/compare/presentation/widgets/compare_diff_table_widget.dart';
import 'package:youth_road_app/features/policy_new/compare/presentation/widgets/compare_header_row_widget.dart';
import 'package:youth_road_app/features/policy_new/compare/presentation/widgets/compare_summary_highlight.dart';
import 'package:youth_road_app/features/policy_new/compare/presentation/widgets/policy_compare_zoom_controls.dart';
import 'package:youth_road_app/ui/components/horizontal_overflow_container.dart';
import 'package:youth_road_app/ui/theme/app_spacing.dart';

class PolicyCompareCanvas extends StatefulWidget {
  const PolicyCompareCanvas({
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

  static const double _initialScale = 1.0;
  static const double _minScale = 0.8;
  static const double _maxScale = 2.0;
  static const double _zoomStep = 0.1;

  @override
  State<PolicyCompareCanvas> createState() => _PolicyCompareCanvasState();
}

class _PolicyCompareCanvasState extends State<PolicyCompareCanvas> {
  final HorizontalOverflowController _overflowController =
      HorizontalOverflowController();
  final TransformationController _transformationController =
      TransformationController();
  final GlobalKey _viewportKey = GlobalKey();
  double _currentScale = PolicyCompareCanvas._initialScale;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_syncScale);
    _resetZoom(useSetState: false);
  }

  @override
  void didUpdateWidget(covariant PolicyCompareCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.policies.length != widget.state.policies.length) {
      _resetZoom();
    }
  }

  @override
  void dispose() {
    _transformationController.removeListener(_syncScale);
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final service = CompareDiffService();
    final labelWidth = service.labelWidth;
    final mediaHeight = MediaQuery.of(context).size.height;
    final viewportHeight = math.max(mediaHeight * 0.55, 360.0);
    final tableBaseWidth = labelWidth +
        (CompareDiffService.columnWidth + 12) * state.policies.length +
        AppSpacing.lg * 2;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
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
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: CompareHeaderRowWidget(
              policies: state.policies,
              insights: state.insights,
              onRemove: widget.onRemove,
              onOpenDetail: widget.onOpenDetail,
              labelWidth: labelWidth,
              columnWidth: CompareDiffService.columnWidth,
              overflowController: _overflowController,
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: SizedBox(
              key: _viewportKey,
              height: viewportHeight,
              child: ClipRect(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final minContentWidth =
                        math.max(constraints.maxWidth, tableBaseWidth);

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: InteractiveViewer(
                            transformationController: _transformationController,
                            minScale: PolicyCompareCanvas._minScale,
                            maxScale: PolicyCompareCanvas._maxScale,
                            panEnabled: true,
                            scaleEnabled: true,
                            clipBehavior: Clip.none,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: minContentWidth,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CompareSummaryHighlight(
                                        insights: state.insights,
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      CompareDiffTableWidget(
                                        policies: state.policies,
                                        diffs: state.diffs,
                                        insights: state.insights,
                                        fields: service.fields,
                                        labelWidth: labelWidth,
                                        columnWidth: CompareDiffService.columnWidth,
                                        overflowController: _overflowController,
                                      ),
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
                          child: PolicyCompareZoomControls(
                            currentScale: _currentScale,
                            minScale: PolicyCompareCanvas._minScale,
                            maxScale: PolicyCompareCanvas._maxScale,
                            onZoomIn: _handleZoomIn,
                            onZoomOut: _handleZoomOut,
                            onReset: _resetZoom,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleZoomIn() {
    _updateScale(_currentScale + PolicyCompareCanvas._zoomStep);
  }

  void _handleZoomOut() {
    _updateScale(_currentScale - PolicyCompareCanvas._zoomStep);
  }

  void _resetZoom({bool useSetState = true}) {
    final apply = () {
      _currentScale = PolicyCompareCanvas._initialScale;
      _transformationController.value =
          Matrix4.identity()..scale(PolicyCompareCanvas._initialScale);
    };

    if (useSetState) {
      setState(apply);
    } else {
      apply();
    }
  }

  void _syncScale() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    final clampedScale =
        scale.clamp(PolicyCompareCanvas._minScale, PolicyCompareCanvas._maxScale);
    if ((clampedScale - scale).abs() > 0.001) {
      final factor = clampedScale / (scale == 0 ? 1 : scale);
      _transformationController.value.scale(factor);
    }
    if ((clampedScale - _currentScale).abs() > 0.001) {
      setState(() {
        _currentScale = clampedScale;
      });
    }
  }

  void _updateScale(double targetScale) {
    final clampedScale = targetScale.clamp(
      PolicyCompareCanvas._minScale,
      PolicyCompareCanvas._maxScale,
    );
    final matrix = _transformationController.value.clone();
    final currentScale = matrix.getMaxScaleOnAxis();
    final baseMatrix = currentScale > 0 ? matrix : Matrix4.identity();
    final factor = clampedScale / (currentScale > 0 ? currentScale : 1.0);

    final renderBox =
        _viewportKey.currentContext?.findRenderObject() as RenderBox?;
    final viewportSize = renderBox?.size ?? context.size;
    final focalPoint = viewportSize?.center(Offset.zero);

    final updatedMatrix = focalPoint != null
        ? (Matrix4.identity()
              ..translate(focalPoint.dx, focalPoint.dy)
              ..scale(factor)
              ..translate(-focalPoint.dx, -focalPoint.dy))
            .multiplied(baseMatrix)
        : (baseMatrix.clone()..scale(factor));

    setState(() {
      _currentScale = clampedScale;
      _transformationController.value = updatedMatrix;
    });
  }
}
