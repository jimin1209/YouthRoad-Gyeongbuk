import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_strings.dart';
import '../debug/debug_wrapper.dart';
import '../theme/app_theme.dart';
import 'providers/app_providers.dart';

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
      builder: (context, child) {
        if (!kDebugMode) {
          return child ?? const SizedBox.shrink();
        }

        return DebugWrapper(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

typedef App = YouthRoadApp;
