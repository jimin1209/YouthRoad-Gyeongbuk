import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'debug_button.dart';
import 'debug_overlay.dart';
import 'debug_settings_provider.dart';
import 'debug_toast.dart';

class DebugPanelHost extends ConsumerStatefulWidget {
  const DebugPanelHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<DebugPanelHost> createState() => _DebugPanelHostState();
}

class _DebugPanelHostState extends ConsumerState<DebugPanelHost> {
  bool _overlayVisible = false;
  late final ProviderSubscription<bool> _enabledSub;

  @override
  void initState() {
    super.initState();
    _enabledSub = ref.listen<bool>(debugPanelEnabledProvider, (prev, next) {
      if (!next && _overlayVisible) {
        setState(() {
          _overlayVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _enabledSub.close();
    super.dispose();
  }

  void _toggleOverlay(bool visible) {
    setState(() {
      _overlayVisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!debugPanelFeatureAllowed) {
      return widget.child;
    }

    final debugPanelEnabled = ref.watch(debugPanelEnabledProvider);

    if (!debugPanelEnabled) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        const DebugToastOverlay(),
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
