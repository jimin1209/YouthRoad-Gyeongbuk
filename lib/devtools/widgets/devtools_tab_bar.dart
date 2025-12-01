import 'package:flutter/material.dart';

class DevtoolsTabBar extends StatelessWidget {
  const DevtoolsTabBar({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: TabBar(
        controller: controller,
        indicatorColor: const Color(0xFF0EA5E9),
        labelColor: const Color(0xFF0EA5E9),
        unselectedLabelColor: const Color(0xFF94A3B8),
        tabs: const [
          Tab(text: 'Provider'),
          Tab(text: 'Network'),
          Tab(text: 'WebView'),
          Tab(text: 'Logs'),
        ],
      ),
    );
  }
}
