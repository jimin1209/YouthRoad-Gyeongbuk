import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

import '../../policy/controller/policy_list_controller.dart';

enum UnityMessageType {
  setSelectedRegion('SET_SELECTED_REGION'),
  highlightRegion('HIGHLIGHT_REGION'),
  setMode('SET_MODE'),
  updateRegionStats('UPDATE_REGION_STATS'),
  regionSelected('REGION_SELECTED'),
  mapReady('MAP_READY');

  const UnityMessageType(this.value);
  final String value;
}

final unityControllerProvider =
    NotifierProvider<UnityController, UnityState>(UnityController.new);

class UnityState {
  final String? selectedRegionCode;
  final String? selectedRegionName;
  final bool isReady;

  const UnityState({
    this.selectedRegionCode,
    this.selectedRegionName,
    this.isReady = false,
  });

  UnityState copyWith({
    String? selectedRegionCode,
    String? selectedRegionName,
    bool? isReady,
  }) {
    return UnityState(
      selectedRegionCode: selectedRegionCode ?? this.selectedRegionCode,
      selectedRegionName: selectedRegionName ?? this.selectedRegionName,
      isReady: isReady ?? this.isReady,
    );
  }
}

class UnityController extends Notifier<UnityState> {
  @override
  UnityState build() => const UnityState();

  String buildMessage(UnityMessageType type, Map<String, dynamic> payload) {
    return jsonEncode({
      'type': type.value,
      'payload': payload,
    });
  }

  Future<void> sendMessage(
    UnityWidgetController controller,
    UnityMessageType type, {
    Map<String, dynamic> payload = const {},
    String gameObject = 'MapController',
    String methodName = 'OnFlutterMessage',
  }) async {
    final message = buildMessage(type, payload);
    controller.postMessage(gameObject, methodName, message);
  }

  void handleMessage(String message) {
    final decoded = jsonDecode(message) as Map<String, dynamic>;
    final type = decoded['type'] as String?;
    final payload = decoded['payload'] as Map<String, dynamic>? ?? {};
    switch (type) {
      case 'REGION_SELECTED':
        _onRegionSelected(payload);
        break;
      case 'MAP_READY':
        state = state.copyWith(isReady: true);
        break;
      default:
        break;
    }
  }

  void _onRegionSelected(Map<String, dynamic> payload) {
    final regionCode = payload['regionCode'] as String?;
    final regionName = payload['regionName'] as String?;
    state = state.copyWith(
      selectedRegionCode: regionCode,
      selectedRegionName: regionName,
    );
    if (regionCode != null) {
      ref.read(policyFilterUseProfileProvider.notifier).state = false;
      final notifier = ref.read(policyFilterStateProvider.notifier);
      notifier.state = notifier.state.copyWith(region: regionCode);
    }
  }
}
