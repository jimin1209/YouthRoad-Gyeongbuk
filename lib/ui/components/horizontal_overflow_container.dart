import 'package:flutter/material.dart';

class HorizontalOverflowController {
  ScrollController? _controller;

  ScrollController _ensureAttached() {
    return _controller ??= ScrollController();
  }

  Future<void> scrollToIndex(
    int index, {
    double itemExtent = 180,
    Duration duration = const Duration(milliseconds: 240),
    Curve curve = Curves.easeOutCubic,
  }) async {
    final controller = _controller;
    if (controller == null || !controller.hasClients) return;
    final target = (itemExtent * index).clamp(
      0,
      controller.position.maxScrollExtent,
    ).toDouble();
    await controller.animateTo(target, duration: duration, curve: curve);
  }
}

class HorizontalOverflowContainer extends StatefulWidget {
  const HorizontalOverflowContainer({
    super.key,
    this.child,
    this.children,
    this.minWidth,
    this.minWidthPerChild = 180,
    this.gap = 12,
    this.padding = EdgeInsets.zero,
    this.controller,
    this.showBoundaries = true,
  });

  final Widget? child;
  final List<Widget>? children;
  final double? minWidth;
  final double minWidthPerChild;
  final double gap;
  final EdgeInsets padding;
  final HorizontalOverflowController? controller;
  final bool showBoundaries;

  @override
  State<HorizontalOverflowContainer> createState() =>
      _HorizontalOverflowContainerState();
}

class _HorizontalOverflowContainerState
    extends State<HorizontalOverflowContainer> {
  late final ScrollController _controller;
  bool _showLeftShade = false;
  bool _showRightShade = false;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = ScrollController();
      _ownsController = true;
    } else {
      _controller = widget.controller!._ensureAttached();
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.children;
    final content = widget.child ??
        Row(
          children: _withGaps(children ?? const <Widget>[], widget.gap),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final minWidth = widget.minWidth ??
            ((children?.length ?? 0) * widget.minWidthPerChild);

        return Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                _updateShades(notification.metrics);
                return false;
              },
              child: SingleChildScrollView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: minWidth > 0
                        ? minWidth
                        : constraints.hasBoundedWidth
                            ? constraints.maxWidth
                            : 0,
                  ),
                  child: Padding(
                    padding: widget.padding,
                    child: content,
                  ),
                ),
              ),
            ),
            if (widget.showBoundaries && _showLeftShade)
              _edgeShade(Alignment.centerLeft),
            if (widget.showBoundaries && _showRightShade)
              _edgeShade(Alignment.centerRight),
          ],
        );
      },
    );
  }

  void _updateShades(ScrollMetrics metrics) {
    final showLeft = metrics.pixels > metrics.minScrollExtent + 0.5;
    final showRight = metrics.pixels < metrics.maxScrollExtent - 0.5;
    if (showLeft != _showLeftShade || showRight != _showRightShade) {
      setState(() {
        _showLeftShade = showLeft;
        _showRightShade = showRight;
      });
    }
  }

  Widget _edgeShade(Alignment alignment) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Container(
          width: 24,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: alignment == Alignment.centerLeft
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              end: alignment == Alignment.centerLeft
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              colors: [
                Colors.black.withOpacity(0.08),
                Colors.black.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> _withGaps(List<Widget> items, double gap) {
  if (items.isEmpty) return items;
  final spaced = <Widget>[];
  for (var i = 0; i < items.length; i++) {
    spaced.add(items[i]);
    if (i != items.length - 1 && gap > 0) {
      spaced.add(SizedBox(width: gap));
    }
  }
  return spaced;
}
