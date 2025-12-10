import 'package:flutter/material.dart';

import 'debug_log_collector.dart';
import 'debug_network_logger.dart';
import 'debug_provider_tracker.dart';
import 'debug_unity_logger.dart';

class DebugOverlay extends StatefulWidget {
  const DebugOverlay({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<DebugOverlay> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0x8C000000),
        child: SafeArea(
          child: DefaultTabController(
            length: 5,
            child: Builder(
              builder: (context) {
                final tabController = DefaultTabController.of(context);
                if (tabController == null) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DebugOverlayAppBar(onClose: widget.onClose),
                    const _DebugTabBar(),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE2E8F0),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _AnimatedTabContent(
                            controller: tabController,
                            tabIndex: 0,
                            child: const DebugProviderPanel(),
                          ),
                          _AnimatedTabContent(
                            controller: tabController,
                            tabIndex: 1,
                            child: const DebugNetworkPanel(),
                          ),
                          _AnimatedTabContent(
                            controller: tabController,
                            tabIndex: 2,
                            child: const DebugUnityPanel(),
                          ),
                          _AnimatedTabContent(
                            controller: tabController,
                            tabIndex: 3,
                            child: const DebugLogPanel(),
                          ),
                          _AnimatedTabContent(
                            controller: tabController,
                            tabIndex: 4,
                            child: const DebugErrorLogPanel(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedTabContent extends StatelessWidget {
  const _AnimatedTabContent({
    required this.controller,
    required this.tabIndex,
    required this.child,
  });

  final TabController controller;
  final int tabIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = controller.animation!;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final distance = (tabIndex - animation.value).abs();
        final t = (1 - distance).clamp(0.0, 1.0);
        final curved = Curves.easeOut.transform(t);
        final offsetY = (1 - curved) * 18;
        return Opacity(
          opacity: curved,
          child: Transform.translate(
            offset: Offset(0, offsetY),
            child: child,
          ),
        );
      },
    );
  }
}

class _DebugOverlayAppBar extends StatelessWidget {
  const _DebugOverlayAppBar({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 52,
            child: Row(
              children: [
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: Color(0xFF4D8AF0)),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Debug Overlay',
                  style: TextStyle(
                    color: Color(0xFF4D8AF0),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DebugTabBar extends StatelessWidget {
  const _DebugTabBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: TabBar(
        indicatorColor: const Color(0xFF4D8AF0),
        indicatorWeight: 3,
        labelColor: const Color(0xFF4D8AF0),
        unselectedLabelColor: const Color(0xFFA0AEC0),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Provider'),
          Tab(text: 'Network'),
          Tab(text: 'Unity'),
          Tab(text: 'Log'),
          Tab(text: 'Error'),
        ],
      ),
    );
  }
}
