import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_strings.dart';
import '../theme/app_theme.dart';
import 'providers/app_providers.dart';
import '../debug/debug_panel_host.dart';

class YouthRoadApp extends ConsumerWidget {
  const YouthRoadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppStrings.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,

      // 🔥 핵심 수정: DevtoolsOverlay 제거
      builder: (context, child) {
        return DebugPanelHost(child: child ?? const SizedBox.shrink());
      },
    );
  }
}

typedef App = YouthRoadApp;
