import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    state = state.copyWith(
      selectedRegionCode: payload['regionCode'] as String?,
      selectedRegionName: payload['regionName'] as String?,
    );
  }
}
