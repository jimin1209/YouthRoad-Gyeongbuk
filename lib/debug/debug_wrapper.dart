import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'debug_button.dart';
import 'debug_overlay.dart';
import 'debug_toast.dart';

class DebugWrapper extends StatefulWidget {
  const DebugWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<DebugWrapper> createState() => _DebugWrapperState();
}

class _DebugWrapperState extends State<DebugWrapper> {
  bool _overlayVisible = false;

  void _toggleOverlay(bool visible) {
    setState(() {
      _overlayVisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        if (kDebugMode) const DebugToastOverlay(),
        if (_overlayVisible)
          DebugOverlay(
            onClose: () => _toggleOverlay(false),
          ),
        if (!_overlayVisible)
          DebugButton(
            onPressed: () => _toggleOverlay(true),
          ),
      ],
    );
  }
}
