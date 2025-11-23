import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_strings.dart';
import 'debug/debug_wrapper.dart';
import 'navigation/app_router.dart';
import 'theme/app_theme.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return const AppRouter().router();
});

class App extends ConsumerWidget {
  const App({super.key});

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
