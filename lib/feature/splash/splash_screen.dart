import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/loading_view.dart';
import '../region/region_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_bootstrap);
  }

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final region = ref.read(selectedRegionProvider);
    if (!mounted) return;
    if (region == null || region.code.isEmpty) {
      context.go('/region/select');
    } else {
      context.go('/policy/list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingView(
          message: '로딩 중...',
          fullscreen: true,
        ),
      ),
    );
  }
}
