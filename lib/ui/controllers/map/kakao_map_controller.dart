import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../screens/map/kakao_map_html_builder.dart';

enum KakaoMapEventType {
  ready,
  markerTap,
  mapTap,
  clusterTap,
  loading,
  error,
  mapType,
  log,
  heartbeat,
  unknown,
}

class KakaoMapMessage {
  const KakaoMapMessage({
    required this.type,
    required this.payload,
    this.timestamp,
    this.origin,
    this.logLevel,
    this.raw,
  });

  factory KakaoMapMessage.fromRaw(String message) {
    try {
      final decoded = jsonDecode(message);
      if (decoded is Map<String, dynamic>) {
        return KakaoMapMessage(
          type: decoded['type']?.toString() ?? 'unknown',
          payload: (decoded['payload'] as Map?)?.cast<String, dynamic>() ??
              decoded.map((key, value) => MapEntry(key.toString(), value)),
          timestamp: decoded['timestamp'] is num
              ? DateTime.fromMillisecondsSinceEpoch(decoded['timestamp'] as int)
              : null,
          origin: decoded['origin']?.toString(),
          logLevel: decoded['logLevel']?.toString(),
          raw: message,
        );
      }
    } catch (_) {
      // handled by fallback below
    }
    return KakaoMapMessage(
      type: 'log',
      payload: {'message': message},
      logLevel: 'raw',
      raw: message,
    );
  }

  final String type;
  final Map<String, dynamic> payload;
  final DateTime? timestamp;
  final String? origin;
  final String? logLevel;
  final String? raw;

  String? get markerId => payload['id'] as String?;
  KakaoMapLatLng? get position {
    final lat = payload['lat'];
    final lng = payload['lng'];
    if (lat is num && lng is num) {
      return KakaoMapLatLng(lat.toDouble(), lng.toDouble());
    }
    return null;
  }

  bool get loadingValue => payload['value'] == true;
  String? get errorCode => payload['code']?.toString();
  String? get logMessage => payload['message']?.toString();
}

class KakaoMapEvent {
  const KakaoMapEvent(this.type, this.message);

  final KakaoMapEventType type;
  final KakaoMapMessage message;

  String? get markerId => message.markerId;
  KakaoMapLatLng? get position => message.position;
  bool get loadingValue => message.loadingValue;
  String? get errorCode => message.errorCode;
  String? get logLevel => message.logLevel;
  String? get logMessage => message.logMessage;
}

class _LoadRequest {
  const _LoadRequest({
    required this.center,
    required this.markers,
    required this.polylines,
    required this.options,
    required this.enableClustering,
    this.additionalScripts,
  });

  final KakaoMapLatLng center;
  final List<KakaoMapMarker> markers;
  final List<KakaoMapPolyline> polylines;
  final KakaoMapOptions options;
  final bool enableClustering;
  final String? additionalScripts;
}

class KakaoMapController {
  KakaoMapController({
    required String apiKey,
    required KakaoMapHtmlBuilder builder,
    this.bridgeName = 'KakaoBridge',
    this.baseUrl = 'https://youthroad.co.kr',
    this.maxAutoReloads = 3,
  })  : _apiKey = apiKey,
        _builder = builder {
    _initializeController();
  }

  final String _apiKey;
  final KakaoMapHtmlBuilder _builder;
  final String bridgeName;
  final String baseUrl;
  final int maxAutoReloads;

  final _eventController = StreamController<KakaoMapEvent>.broadcast();
  final List<Future<void> Function()> _pendingActions = [];

  late final WebViewController webViewController;
  bool _ready = false;
  int _reloadAttempts = 0;
  _LoadRequest? _lastLoadRequest;

  Stream<KakaoMapEvent> get events => _eventController.stream;
  bool get isReady => _ready;
  int get reloadAttempts => _reloadAttempts;

  Future<void> load({
    required KakaoMapLatLng center,
    required List<KakaoMapMarker> markers,
    List<KakaoMapPolyline> polylines = const [],
    KakaoMapOptions options = const KakaoMapOptions(),
    bool enableClustering = false,
    String? additionalScripts,
  }) async {
    _lastLoadRequest = _LoadRequest(
      center: center,
      markers: markers,
      polylines: polylines,
      options: options,
      enableClustering: enableClustering,
      additionalScripts: additionalScripts,
    );

    final html = _builder.build(
      apiKey: _apiKey,
      center: center,
      markers: markers,
      polylines: polylines,
      options: options,
      bridgeName: bridgeName,
      enableClustering: enableClustering,
      additionalScripts: additionalScripts,
    );

    _ready = false;
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

  Future<void> animateTo(KakaoMapLatLng center, {int? level}) {
    final levelArg = level != null ? ', $level' : '';
    return _runWhenReady(
      () => webViewController.runJavaScript(
        'window.kakaoMap && window.kakaoMap.animateTo(${center.lat}, ${center.lng}$levelArg);',
      ),
    );
  }

  Future<void> zoomIn() {
    return _runWhenReady(
      () => webViewController.runJavaScript('window.kakaoMap && window.kakaoMap.zoomIn();'),
    );
  }

  Future<void> zoomOut() {
    return _runWhenReady(
      () => webViewController.runJavaScript('window.kakaoMap && window.kakaoMap.zoomOut();'),
    );
  }

  Future<void> fitBounds(List<KakaoMapMarker> markers) {
    final encoded = jsonEncode(markers.map((m) => m.toJson()).toList());
    return _runWhenReady(
      () => webViewController.runJavaScript(
        'window.kakaoMap && window.kakaoMap.fitBounds($encoded);',
      ),
    );
  }

  Future<void> setMapType(KakaoMapType type) {
    return _runWhenReady(
      () => webViewController.runJavaScript(
        "window.kakaoMap && window.kakaoMap.setMapType('${type.name}');",
      ),
    );
  }

  Future<void> reloadMap() async {
    if (_lastLoadRequest != null) {
      _reloadAttempts += 1;
      return load(
        center: _lastLoadRequest!.center,
        markers: _lastLoadRequest!.markers,
        polylines: _lastLoadRequest!.polylines,
        options: _lastLoadRequest!.options,
        enableClustering: _lastLoadRequest!.enableClustering,
        additionalScripts: _lastLoadRequest!.additionalScripts,
      );
    }
    return _runWhenReady(
      () => webViewController.runJavaScript('window.kakaoMap && window.kakaoMap.reloadMap();'),
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

  Future<void> setPolylines(List<KakaoMapPolyline> polylines) {
    final encoded = jsonEncode(polylines.map((p) => p.toJson()).toList());
    return _runWhenReady(
      () => webViewController.runJavaScript(
        'window.kakaoMap && window.kakaoMap.setPolylines($encoded);',
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

  Future<void> clearPolylines() {
    return _runWhenReady(
      () => webViewController.runJavaScript(
        'window.kakaoMap && window.kakaoMap.clearPolylines();',
      ),
    );
  }

  Future<void> runRawScript(String script) {
    return _runWhenReady(() => webViewController.runJavaScript(script));
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
            webViewController.runJavaScript(
              'window.kakaoBootstrap && window.kakaoBootstrap();',
            );
          },
        ),
      )
      ..setOnConsoleMessage(
        (message) => debugPrint('[KAKAO_MAP_WEBVIEW][${message.level}] ${message.message}'),
      );
  }

  void _handleMessage(JavaScriptMessage message) {
    final parsed = KakaoMapMessage.fromRaw(message.message);
    final type = _mapType(parsed.type);
    final event = KakaoMapEvent(type, parsed);

    if (type == KakaoMapEventType.ready) {
      _ready = true;
      _reloadAttempts = 0;
      _flushPendingActions();
    }

    if (type == KakaoMapEventType.error) {
      _handleErrorCode(parsed.errorCode);
    }

    _eventController.add(event);
  }

  void _handleErrorCode(String? code) {
    if (code == null) return;
    final lower = code.toLowerCase();
    if (_reloadAttempts >= maxAutoReloads) return;
    if (lower.contains('sdkfail') || lower.contains('timeout')) {
      _reloadAttempts += 1;
      reloadMap();
    }
  }

  KakaoMapEventType _mapType(String? raw) {
    switch (raw) {
      case 'ready':
        return KakaoMapEventType.ready;
      case 'marker':
        return KakaoMapEventType.markerTap;
      case 'map':
        return KakaoMapEventType.mapTap;
      case 'cluster':
        return KakaoMapEventType.clusterTap;
      case 'loading':
        return KakaoMapEventType.loading;
      case 'error':
      case 'sdkFail':
      case 'timeout':
      case 'jsException':
        return KakaoMapEventType.error;
      case 'map_type':
        return KakaoMapEventType.mapType;
      case 'log':
        return KakaoMapEventType.log;
      case 'heartbeat':
        return KakaoMapEventType.heartbeat;
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
