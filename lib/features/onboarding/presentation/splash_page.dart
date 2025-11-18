import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_store.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStoreProvider);
    Future.microtask(() {
      if (!context.mounted) return;
      final nextRoute = appState.onboardingCompleted ? '/home' : '/onboarding';
      context.go(nextRoute);
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
