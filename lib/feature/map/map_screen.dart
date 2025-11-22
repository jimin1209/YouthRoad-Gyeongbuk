import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../region/region_provider.dart';
import 'unity_map_controller.dart';
import 'youth_unity_map_view.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final region = ref.watch(selectedRegionProvider);
    final controller = ref.watch(unityMapControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('경북 지도'),
      ),
      body: const YouthUnityMapView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final code = region?.code;
          if (code != null && code.isNotEmpty) {
            controller.focusRegion(code);
          }
        },
        label: Text('지역 강조: ${region?.name ?? '미선택'}'),
        icon: const Icon(Icons.my_location),
      ),
    );
  }
}
