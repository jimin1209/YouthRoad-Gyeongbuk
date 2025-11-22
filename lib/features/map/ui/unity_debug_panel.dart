import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youth_road_app/feature/map/youth_unity_map_view.dart';
import '../controller/unity_init_fix.dart';

/// Unity ↔ Flutter 메시지 테스트용 패널 (UI-only mock).
class UnityDebugPanel extends ConsumerWidget {
  const UnityDebugPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(unityMapControllerProvider);
    final ready = ref.watch(unityReadyProvider);
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unity Debug', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: ready
                      ? () => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Ping Unity (mock)')))
                      : null,
                  child: const Text('Ping Unity'),
                ),
                OutlinedButton(
                  onPressed: ready ? () => controller.focusRegion('PLA0020005') : null,
                  child: const Text('Send Region Test'),
                ),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Unity 로그 표시 (mock)')));
                  },
                  child: const Text('Show Unity Log'),
                ),
              ],
            ),
            Text('Ready: $ready'),
          ],
        ),
      ),
    );
  }
}
