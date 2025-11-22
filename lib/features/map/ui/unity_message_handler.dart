import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/map_controller.dart';

/// Unity → Flutter 메시지를 받아 지도 선택을 반영.
class UnityMessageHandler {
  UnityMessageHandler(this.ref);

  final Ref ref;

  void handle(dynamic message) {
    try {
      final Map<String, dynamic> data = jsonDecode(message.toString()) as Map<String, dynamic>;
      if (data['event'] == 'onRegionClick') {
        final String? code = data['regionCode'] as String?;
        if (code != null) {
          ref.read(mapControllerProvider).onRegionSelected(code);
        }
      }
    } catch (_) {
      // ignore malformed
    }
  }
}

final unityMessageHandlerProvider = Provider<UnityMessageHandler>((ref) {
  return UnityMessageHandler(ref);
});
