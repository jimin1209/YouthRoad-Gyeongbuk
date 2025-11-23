import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

import '../../domain/entities/policy.dart';
import '../providers.dart';

/// Provides a bridge between Flutter and Unity for marker exchange on the map
/// scene.
///
/// Message contract (stringified JSON):
/// - Flutter -> Unity
///   ```json
///   { "type": "markers", "items": [{ "id": "...", "title": "..." }] }
///   ```
///   Sent to GameObject `MapController` calling method
///   `ReceiveFlutterMessage(string json)`.
///
/// - Unity -> Flutter
///   ```json
///   { "type": "markerTap", "policyId": "..." }
///   ```
///   Unity should invoke `UnityMessageManager.Instance.SendMessageToFlutter(json)`
///   with this payload when a marker is tapped.
final unityMapControllerProvider =
    Provider.autoDispose<UnityMapController>((ref) {
  return UnityMapController(ref);
});

typedef UnityMarkerTapCallback = void Function(Policy policy);

class UnityMapController {
  UnityMapController(this._ref);

  final Ref _ref;

  UnityWidgetController? _unityController;
  UnityMarkerTapCallback? onPolicySelected;

  bool get isUnityReady => _unityController != null;

  void onUnityCreated(UnityWidgetController controller) {
    _unityController = controller;
    _sendCurrentPolicies();
  }

  void onUnityMessage(dynamic message) {
    dynamic payload = message;

    if (message is UnityMessage) {
      payload = message.data ?? message.toString();
    }

    if (payload is String) {
      _parseMessage(payload);
    } else if (payload is Map<String, dynamic>) {
      _handleParsedMessage(payload);
    }
  }

  void sendMarkersForPolicies(List<Policy> policies) {
    _sendMarkers(policies);
  }

  void _parseMessage(String message) {
    try {
      final decoded = jsonDecode(message);
      if (decoded is Map<String, dynamic>) {
        _handleParsedMessage(decoded);
      }
    } catch (_) {
      // Ignore invalid JSON payloads.
    }
  }

  void _handleParsedMessage(Map<String, dynamic> decoded) {
    final type = decoded['type'];
    if (type == 'markerTap') {
      final policyId = decoded['policyId'];
      if (policyId is String && policyId.isNotEmpty) {
        _handleMarkerTap(policyId);
      }
    }
  }

  void _sendCurrentPolicies() {
    final asyncPolicies = _ref.read(policyListNotifierProvider);
    final policies = asyncPolicies.valueOrNull;
    if (policies == null || policies.isEmpty) return;

    _sendMarkers(policies);
  }

  void _sendMarkers(List<Policy> policies) {
    final controller = _unityController;
    if (controller == null || policies.isEmpty) return;

    final payload = {
      'type': 'markers',
      'items': policies
          .map((policy) => {
                'id': policy.id,
                'title': policy.title,
              })
          .toList(),
    };

    controller.postMessage(
      'MapController',
      'ReceiveFlutterMessage',
      jsonEncode(payload),
    );
  }

  void _handleMarkerTap(String policyId) {
    final policies =
        _ref.read(policyListNotifierProvider).valueOrNull ?? const <Policy>[];

    Policy? tapped;
    for (final policy in policies) {
      if (policy.id == policyId) {
        tapped = policy;
        break;
      }
    }

    if (tapped == null) return;

    final handler = onPolicySelected;
    if (handler != null) {
      handler(tapped);
    }
  }
}
