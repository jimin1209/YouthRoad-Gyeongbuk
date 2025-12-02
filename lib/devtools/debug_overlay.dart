import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../debug/debug_settings_provider.dart';
import 'devtools_provider.dart';
import 'panels/log_console_panel.dart';
import 'panels/network_inspector_panel.dart';
import 'panels/provider_tracker_panel.dart';
import 'panels/webview_console_panel.dart';
import 'widgets/devtools_container.dart';
import 'widgets/devtools_tab_bar.dart';

class DevtoolsOverlay extends ConsumerStatefulWidget {
  const DevtoolsOverlay({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<DevtoolsOverlay> createState() => _DevtoolsOverlayState();
}

class _DevtoolsOverlayState extends ConsumerState<DevtoolsOverlay> {
  bool _buttonVisible = false;
  Timer? _revealTimer;
  ProviderSubscription<bool>? _debugPanelSubscription;

  @override
  void initState() {
    super.initState();
    final enabled = ref.read(debugPanelEnabledProvider);
    if (enabled) {
      _scheduleReveal();
    }
    _debugPanelSubscription =
        ref.listenManual<bool>(debugPanelEnabledProvider, (previous, next) {
      if (!next) {
        _revealTimer?.cancel();
        if (mounted) {
          setState(() => _buttonVisible = false);
        }
        return;
      }
      _scheduleReveal();
    });
  }

  @override
  void dispose() {
    _revealTimer?.cancel();
    _debugPanelSubscription?.close();
    super.dispose();
  }

  void _revealButton() {
    if (_buttonVisible) return;
    setState(() {
      _buttonVisible = true;
    });
  }

  void _scheduleReveal() {
    _revealTimer?.cancel();
    _revealTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted || _buttonVisible) return;
      setState(() {
        _buttonVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return widget.child;
    }

    final isEnabled = ref.watch(debugPanelEnabledProvider);
    if (!isEnabled) {
      return widget.child;
    }

    final state = ref.watch(devtoolsProvider);
    final notifier = ref.read(devtoolsProvider.notifier);

    return Stack(
      children: [
        widget.child,
        if (state.isOpen)
          DevtoolsContainer(
            onClose: notifier.closeOverlay,
            builder: (context) => _DevtoolsTabView(
              initialIndex: state.activeTab,
              onTabChanged: notifier.setActiveTab,
            ),
          ),
        if (!state.isOpen)
          Positioned(
            right: 20,
            bottom: 24,
            child: GestureDetector(
              onLongPress: _revealButton,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 56,
                height: 56,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 240),
                  opacity: _buttonVisible ? 1 : 0,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: notifier.toggleOverlay,
                    backgroundColor: const Color(0xFF1E293B).withOpacity(0.82),
                    child: const Icon(Icons.bug_report, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DevtoolsTabView extends StatefulWidget {
  const _DevtoolsTabView({
    required this.initialIndex,
    required this.onTabChanged,
  });

  final int initialIndex;
  final ValueChanged<int> onTabChanged;

  @override
  State<_DevtoolsTabView> createState() => _DevtoolsTabViewState();
}

class _DevtoolsTabViewState extends State<_DevtoolsTabView>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
    _controller.index = widget.initialIndex.clamp(0, 3);
    _controller.addListener(_onTabChanged);
  }

  @override
  void didUpdateWidget(covariant _DevtoolsTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex &&
        widget.initialIndex != _controller.index) {
      _controller.index = widget.initialIndex.clamp(0, 3);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTabChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_controller.indexIsChanging) return;
    widget.onTabChanged(_controller.index);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: _controller.index,
      child: Column(
        children: [
          DevtoolsTabBar(controller: _controller),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: TabBarView(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              children: const <Widget>[
                ProviderTrackerPanel(),
                NetworkInspectorPanel(),
                WebViewConsolePanel(),
                LogConsolePanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
