import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      // TODO: replace with onboarding completion check.
      context.go('/onboarding');
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
