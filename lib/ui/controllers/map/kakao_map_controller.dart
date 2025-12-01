import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../screens/map/kakao_map_html_builder.dart';

enum KakaoMapEventType { ready, markerTap, mapTap, log, unknown }

class KakaoMapEvent {
  const KakaoMapEvent(this.type, this.payload);

  final KakaoMapEventType type;
  final Map<String, dynamic> payload;

  String? get markerId => payload['id'] as String?;

  KakaoMapLatLng? get position {
    final lat = payload['lat'];
    final lng = payload['lng'];
    if (lat is num && lng is num) {
      return KakaoMapLatLng(lat.toDouble(), lng.toDouble());
    }
    return null;
  }
}

class KakaoMapController {
  KakaoMapController({
    required String apiKey,
    required KakaoMapHtmlBuilder builder,
    this.bridgeName = 'KakaoBridge',
    this.baseUrl = 'https://youthroad.co.kr',
  })  : _apiKey = apiKey,
        _builder = builder {
    _initializeController();
  }

  final String _apiKey;
  final KakaoMapHtmlBuilder _builder;
  final String bridgeName;
  final String baseUrl;

  final _eventController = StreamController<KakaoMapEvent>.broadcast();
  final List<Future<void> Function()> _pendingActions = [];

  late final WebViewController webViewController;
  bool _ready = false;

  Stream<KakaoMapEvent> get events => _eventController.stream;
  bool get isReady => _ready;

  Future<void> load({
    required KakaoMapLatLng center,
    required List<KakaoMapMarker> markers,
  }) async {
    final html = _builder.build(
      apiKey: _apiKey,
      center: center,
      markers: markers,
      bridgeName: bridgeName,
    );

    await webViewController.loadHtmlString(html, baseUrl: baseUrl);
  }

  Future<void> moveTo(KakaoMapLatLng center, {int? level}) {
    final levelArg = level != null ? ', $level' : '';
    return _runWhenReady(
      () => webViewController.runJavaScript(
        'window.kakaoMap && window.kakaoMap.moveTo(${center.lat}, ${center.lng}$levelArg);',
      ),
    );
  }

  Future<void> setMarkers(List<KakaoMapMarker> markers) {
    final encoded = jsonEncode(markers.map((m) => m.toJson()).toList());
    return _runWhenReady(
      () => webViewController.runJavaScript(
        'window.kakaoMap && window.kakaoMap.setMarkers($encoded);',
      ),
    );
  }

  Future<void> clearMarkers() {
    return _runWhenReady(
      () => webViewController.runJavaScript(
        'window.kakaoMap && window.kakaoMap.clearMarkers();',
      ),
    );
  }

  Future<void> _runWhenReady(Future<void> Function() action) {
    if (_ready) {
      return action();
    }
    final completer = Completer<void>();
    _pendingActions.add(() async {
      try {
        await action();
        completer.complete();
      } catch (e, s) {
        completer.completeError(e, s);
      }
    });
    return completer.future;
  }

  void _initializeController() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        bridgeName,
        onMessageReceived: _handleMessage,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            _ready = false;
          },
        ),
      )
      ..setOnConsoleMessage(
        (message) => debugPrint('[KAKAO_MAP_WEBVIEW][${message.level}] ${message.message}'),
      );
  }

  void _handleMessage(JavaScriptMessage message) {
    final content = message.message;
    Map<String, dynamic> parsed = {};
    try {
      parsed = jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      parsed = {'type': 'log', 'payload': {'message': content}};
    }

    final type = _mapType(parsed['type'] as String?);
    final payload = (parsed['payload'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
    final event = KakaoMapEvent(type, payload);

    if (type == KakaoMapEventType.ready) {
      _ready = true;
      _flushPendingActions();
    }

    _eventController.add(event);
  }

  KakaoMapEventType _mapType(String? raw) {
    switch (raw) {
      case 'ready':
        return KakaoMapEventType.ready;
      case 'marker_tap':
        return KakaoMapEventType.markerTap;
      case 'map_tap':
        return KakaoMapEventType.mapTap;
      case 'log':
        return KakaoMapEventType.log;
      default:
        return KakaoMapEventType.unknown;
    }
  }

  Future<void> _flushPendingActions() async {
    if (_pendingActions.isEmpty) return;
    final tasks = List<Future<void> Function()>.from(_pendingActions);
    _pendingActions.clear();
    for (final action in tasks) {
      try {
        await action();
      } catch (e, s) {
        debugPrint('[KAKAO_MAP_WEBVIEW] Pending action failed: $e\n$s');
      }
    }
  }

  void dispose() {
    _eventController.close();
    _pendingActions.clear();
  }
}
