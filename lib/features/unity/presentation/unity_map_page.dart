import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

import '../controller/unity_controller.dart';

class UnityMapPage extends ConsumerStatefulWidget {
  const UnityMapPage({super.key, this.initialRegionCode, this.initialRegionName});

  final String? initialRegionCode;
  final String? initialRegionName;

  @override
  ConsumerState<UnityMapPage> createState() => _UnityMapPageState();
}

class _UnityMapPageState extends ConsumerState<UnityMapPage> {
  UnityWidgetController? _unityWidgetController;
  bool _initialRegionDispatched = false;

  void _onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
    _dispatchInitialRegion();
  }

  void _onUnityMessage(UnityMessage message) {
    final raw = message.rawMessage ?? message.toString();
    ref.read(unityControllerProvider.notifier).handleMessage(raw);
  }

  void _dispatchInitialRegion() {
    final controller = _unityWidgetController;
    final code = widget.initialRegionCode;
    if (controller == null || code == null || _initialRegionDispatched) {
      return;
    }
    final unityCtrl = ref.read(unityControllerProvider.notifier);
    unityCtrl.sendMessage(
      controller,
      UnityMessageType.highlightRegion,
      payload: {
        'regionCode': code,
        'regionName': widget.initialRegionName ?? code,
      },
    );
    _initialRegionDispatched = true;
  }

  @override
  Widget build(BuildContext context) {
    final unityState = ref.watch(unityControllerProvider);
    final unityCtrl = ref.read(unityControllerProvider.notifier);

    if (unityState.isReady) {
      _dispatchInitialRegion();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Unity Map')),
      body: Column(
        children: [
          Expanded(
            child: UnityWidget(
              onUnityCreated: _onUnityCreated,
              onUnityMessage: _onUnityMessage,
            ),
          ),
          ListTile(
            title: Text('선택된 지역: ${unityState.selectedRegionName ?? '-'}'),
            subtitle: Text('코드: ${unityState.selectedRegionCode ?? '-'}'),
            trailing: unityState.isReady
                ? const Chip(label: Text('Ready'))
                : const Chip(label: Text('Loading...')),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _unityWidgetController == null
                      ? null
                      : () {
                          unityCtrl.sendMessage(
                            _unityWidgetController!,
                            UnityMessageType.setSelectedRegion,
                            payload: {
                              'regionCode': 'GB-GS',
                              'regionName': 'Gyeongsan',
                            },
                          );
                        },
                  child: const Text('경산 선택 요청 보내기'),
                ),
                ElevatedButton(
                  onPressed: () {
                    const incoming =
                        '{"type":"REGION_SELECTED","payload":{"regionCode":"GB-GS","regionName":"Gyeongsan"}}';
                    unityCtrl.handleMessage(incoming);
                  },
                  child: const Text('Unity 응답 시뮬레이션'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
