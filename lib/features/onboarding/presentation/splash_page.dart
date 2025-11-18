import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controller/onboarding_controller.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingStateProvider);
    Future.microtask(() {
      if (!context.mounted) return;
      final nextRoute = onboardingState.completed ? '/home' : '/onboarding';
      context.go(nextRoute);
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
