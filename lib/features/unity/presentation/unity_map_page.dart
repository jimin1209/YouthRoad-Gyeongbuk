import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

import '../controller/unity_controller.dart';
import '../controller/unity_runtime_guard.dart';

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
    final state = ref.read(unityControllerProvider);
    if (!state.isReady) {
      return;
    }
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
    final availabilityAsync = ref.watch(unityRuntimeAvailabilityProvider);
    final unityCtrl = ref.read(unityControllerProvider.notifier);

    if (unityState.isReady && !_initialRegionDispatched) {
      _dispatchInitialRegion();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Unity Map')),
      body: availabilityAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text('장치 ABI 정보를 불러오지 못해 Unity를 비활성화했습니다.'),
        ),
        data: (availability) {
          if (!availability.isSupported) {
            final reason =
                availability.blockingReason() ?? 'Unity가 이 기기에서 비활성화되었습니다.';
            return _UnityDisabledMessage(reason: reason);
          }

          return Column(
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
          );
        },
      ),
    );
  }
}

class _UnityDisabledMessage extends StatelessWidget {
  const _UnityDisabledMessage({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unity 뷰가 비활성화되었습니다',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(reason),
          const SizedBox(height: 8),
          const Text(
            '물리 디바이스에서는 기본 arm64 빌드가 동작합니다. x86_64 에뮬레이터에서 Unity를 테스트하려면 Unity Export Target Architecture에 x86_64를 추가하고 android/unityLibrary/src/main/jniLibs/jniStaticLibs에 x86_64가 포함되어 있는지 확인하세요.',
          ),
        ],
      ),
    );
  }
}
