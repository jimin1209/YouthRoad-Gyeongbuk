import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/unity_controller.dart';

class UnityMapPage extends ConsumerWidget {
  const UnityMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unityState = ref.watch(unityControllerProvider);
    final unityCtrl = ref.read(unityControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Unity Map')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black12,
              alignment: Alignment.center,
              child: const Text('Unity widget placeholder (flutter_unity_widget planned)'),
            ),
          ),
          ListTile(
            title: Text('Selected region: ${unityState.selectedRegionName ?? '-'}'),
            subtitle: Text('Code: ${unityState.selectedRegionCode ?? '-'}'),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    final msg = unityCtrl.buildMessage(
                      UnityMessageType.setSelectedRegion,
                      {'regionCode': 'GB-GS', 'regionName': 'Gyeongsan'},
                    );
                    // TODO: unityController.postMessage('MapController','OnFlutterMessage', msg);
                    debugPrint('Send to Unity: $msg');
                  },
                  child: const Text('Send select Gyeongsan'),
                ),
                ElevatedButton(
                  onPressed: () {
                    const incoming =
                        '{"type":"REGION_SELECTED","payload":{"regionCode":"GB-GS","regionName":"Gyeongsan"}}';
                    unityCtrl.handleMessage(incoming);
                  },
                  child: const Text('Simulate Unity message'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
