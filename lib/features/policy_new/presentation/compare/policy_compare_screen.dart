import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../compare/presentation/compare_tab.dart';

/// 단독 화면으로 비교 UI를 띄울 때 사용하는 래퍼 스크린입니다.
class PolicyCompareScreen extends ConsumerWidget {
  const PolicyCompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 비교'),
      ),
      body: const CompareTab(),
    );
  }
}
