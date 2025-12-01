import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/policy/policy_prefetch_provider.dart';
import '../../navigation/route_paths.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(policyPrefetchProvider.notifier).prefetchPolicies();
      if (mounted) {
        unawaited(_goHome());
      }
    });
  }

  Future<void> _goHome() async {
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 150));
    if (mounted) {
      context.go(RoutePaths.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            Text('청년 정책을 준비하고 있어요...'),
          ],
        ),
      ),
    );
  }
}
