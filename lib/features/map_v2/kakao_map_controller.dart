import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'kakao_map_html_builder.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// 이벤트 타입
/// ─────────────────────────────────────────────────────────────────────────────
enum KakaoMapEventType {
  ready,
  markerTap,
  markerClicked,
  mapTap,
  clusterTap,
  mapMove,
  loading,
  error,
  mapType,
  log,
  heartbeat,
  unknown,
}

/// ─────────────────────────────────────────────────────────────────────────────
/// JS → Dart로 전달되는 메시지
/// ─────────────────────────────────────────────────────────────────────────────
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
              decoded.map(
                (key, value) => MapEntry(key.toString(), value),
              ),
          timestamp: decoded['timestamp'] is num
              ? DateTime.fromMillisecondsSinceEpoch(
                  decoded['timestamp'] as int,
                )
              : null,
          origin: decoded['origin']?.toString(),
          logLevel: decoded['logLevel']?.toString(),
          raw: message,
        );
      }
    } catch (_) {
      // fallback 아래로
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

  String? get markerId {
    final id = payload['id'] as String?;
    if (id != null) return id;
    final rawPayload = payload['payload'];
    if (rawPayload is String) return rawPayload;
    if (rawPayload is Map<String, dynamic>) {
      return rawPayload['id'] as String?;
    }
    return null;
  }

  KakaoMapLatLng? get position {
    final lat = payload['lat'];
    final lng = payload['lng'];
    if (lat is num && lng is num) {
      return KakaoMapLatLng(lat.toDouble(), lng.toDouble());
    }
    return null;
  }

  int? get level {
    final lvl = payload['level'];
    if (lvl is num) return lvl.toInt();
    return null;
  }

  bool get loadingValue => payload['value'] == true;
  String? get errorCode => payload['code']?.toString();
  String? get errorDetail => payload['detail']?.toString();
  String? get logMessage => payload['message']?.toString();

  @override
  String toString() {
    return 'KakaoMapMessage(type: $type, '
        'code: ${errorCode ?? payload['code']}, '
        'level: ${logLevel ?? 'n/a'}, '
        'message: ${logMessage ?? payload['message'] ?? payload['detail']}, '
        'payload: $payload, '
        'origin: ${origin ?? 'unknown'}, '
        'timestamp: ${timestamp?.toIso8601String() ?? 'n/a'})';
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Dart 쪽에서 사용하는 이벤트 래퍼
/// ─────────────────────────────────────────────────────────────────────────────
class KakaoMapEvent {
  const KakaoMapEvent(this.type, this.message);

  final KakaoMapEventType type;
  final KakaoMapMessage message;

  String? get markerId => message.markerId;
  Map<String, dynamic>? get extra => message.payload['extra'] as Map<String, dynamic>?;
  KakaoMapLatLng? get position => message.position;
  int? get level => message.level;
  bool get loadingValue => message.loadingValue;
  String? get errorCode => message.errorCode;
  String? get logLevel => message.logLevel;
  String? get logMessage => message.logMessage;
}

/// ─────────────────────────────────────────────────────────────────────────────
/// 마지막 load 파라미터 기억용
/// ─────────────────────────────────────────────────────────────────────────────
class _LoadRequest {
  const _LoadRequest({
    required this.center,
    required this.markers,
    required this.polylines,
    required this.options,
    required this.enableClustering,
    this.additionalScripts,
    required this.searchRadiusMeters,
  });

  final KakaoMapLatLng center;
  final List<KakaoMapMarker> markers;
  final List<KakaoMapPolyline> polylines;
  final KakaoMapOptions options;
  final bool enableClustering;
  final String? additionalScripts;
  final double searchRadiusMeters;
}

/// ─────────────────────────────────────────────────────────────────────────────
/// KakaoMapController
///   - WebViewController + KakaoMapHtmlBuilder
///   - window.kakaoMap.* 에 JS 호출
/// ─────────────────────────────────────────────────────────────────────────────
class KakaoMapController {
  KakaoMapController({
    required String apiKey,
    required KakaoMapHtmlBuilder builder,
    this.bridgeName = 'KakaoBridge',
    // 카카오 콘솔에 등록한 실제 도메인 (WebView baseUrl)
    this.baseUrl = 'https://gbyouth.co.kr',
    this.maxAutoReloads = 3,
  })  : _apiKey = apiKey,
        _builder = builder {
    _initializeController();
    _logApiKey();
    _logBaseUrl();
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

  bool get hasApiKey => _apiKey.isNotEmpty;
  String get apiKeyPreview => _maskApiKey(_apiKey);

  Stream<KakaoMapEvent> get events => _eventController.stream;
  bool get isReady => _ready;
  int get reloadAttempts => _reloadAttempts;

  /// ---------------------------------------------------------------------------
  /// HTML 로드
  /// ---------------------------------------------------------------------------
  Future<void> load({
    required KakaoMapLatLng center,
    required List<KakaoMapMarker> markers,
    List<KakaoMapPolyline> polylines = const [],
    KakaoMapOptions options = const KakaoMapOptions(),
    double searchRadiusMeters = 20000,
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
      searchRadiusMeters: searchRadiusMeters,
    );

    final html = _builder.build(
      apiKey: _apiKey,
      center: center,
      markers: markers,
      polylines: polylines,
      options: options,
      bridgeName: bridgeName,
      searchRadiusMeters: searchRadiusMeters,
      enableClustering: enableClustering,
      additionalScripts: additionalScripts,
    );

    _ready = false;

    await webViewController.loadHtmlString(
      html,
      baseUrl: baseUrl,
    );
  }

  /// ---------------------------------------------------------------------------
  /// 지도 조작 API
  /// ---------------------------------------------------------------------------
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
      () => webViewController.runJavaScript(
        'window.kakaoMap && window.kakaoMap.zoomIn();',
      ),
    );
  }

  Future<void> zoomOut() {
    return _runWhenReady(
      () => webViewController.runJavaScript(
        'window.kakaoMap && window.kakaoMap.zoomOut();',
      ),
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
    _reloadAttempts += 1;
    return _runWhenReady(
      () => webViewController.runJavaScript(
        'window.kakaoMap && window.kakaoMap.reloadMap();',
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

  Future<void> highlightMarker(
    String markerId,
    KakaoMapLatLng center,
  ) {
    return _runWhenReady(
      () => webViewController.runJavaScript(
        'window.kakaoMap && window.kakaoMap.highlightMarker && '
            "window.kakaoMap.highlightMarker('$markerId', ${center.lat}, ${center.lng});",
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

  Future<void> showMyPosition(KakaoMapLatLng position) {
    final script = '''
      if (window.app && window.app.showMyPosition) {
        window.app.showMyPosition(${position.lat}, ${position.lng});
      }
    ''';
    return _runWhenReady(
      () => webViewController.runJavaScript(script),
    );
  }

  Future<void> moveMapTo(
    KakaoMapLatLng position, {
    int? level,
  }) {
    final levelArg = level != null ? level.toString() : 'undefined';
    final script = '''
      if (window.app && window.app.moveTo) {
        window.app.moveTo(${position.lat}, ${position.lng}, $levelArg);
      }
    ''';
    return _runWhenReady(
      () => webViewController.runJavaScript(script),
    );
  }

  Future<void> updateCircle(
    KakaoMapLatLng center, {
    double? radiusMeters,
  }) {
    final radiusArg =
        radiusMeters != null ? radiusMeters.toString() : 'undefined';
    final script = '''
      if (window.app && window.app.updateCircle) {
        window.app.updateCircle(${center.lat}, ${center.lng}, $radiusArg);
      }
    ''';
    return _runWhenReady(
      () => webViewController.runJavaScript(script),
    );
  }

  /// ---------------------------------------------------------------------------
  /// 내부 로깅
  /// ---------------------------------------------------------------------------
  void _logApiKey() {
    final masked = _maskApiKey(_apiKey);
    if (_apiKey.isEmpty) {
      debugPrint('[Map][ERROR] KakaoMap API Key 가 비어 있습니다. --dart-define=KAKAO_MAP_API_KEY 값을 확인하세요.');
    }
    debugPrint('[KAKAO_MAP_WEBVIEW] Using KakaoMap API Key: $masked');
  }

  void _logBaseUrl() {
    debugPrint('[KAKAO_MAP_WEBVIEW] Using baseUrl: $baseUrl');
  }

  String _maskApiKey(String key) {
    if (key.isEmpty) {
      return '<empty>';
    }
    if (key.length <= 6) {
      return '${key[0]}***${key[key.length - 1]}';
    }
    final prefix = key.substring(0, 3);
    final suffix = key.substring(key.length - 4);
    return '$prefix***$suffix (len:${key.length})';
  }

  /// ---------------------------------------------------------------------------
  /// ready 이후에만 수행해야 하는 JS 호출 큐잉
  /// ---------------------------------------------------------------------------
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

  /// ---------------------------------------------------------------------------
  /// WebView 초기화
  /// ---------------------------------------------------------------------------
  void _initializeController() {
    final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
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
        (message) {
          final levelTag = message.level.name == 'error'
              ? '[MapBridge][ERROR]'
              : '[MapBridge][INFO]';
          debugPrint('$levelTag ${message.message}');
          final log = KakaoMapMessage(
            type: 'log',
            payload: {
              'message': message.message,
              'level': message.level.name,
            },
            logLevel: message.level.name,
            origin: 'kakao-map-js',
            timestamp: DateTime.now(),
          );
          _eventController.add(KakaoMapEvent(KakaoMapEventType.log, log));
        },
      );

    if (controller.platform is AndroidWebViewController) {
      final androidController = controller.platform as AndroidWebViewController;
      AndroidWebViewController.enableDebugging(kDebugMode);
      androidController
        ..setAllowContentAccess(true)
        ..setAllowFileAccess(true)
        ..setOnPlatformPermissionRequest((request) {
          request.grant();
        });
    }

    webViewController = controller;
  }

  /// ---------------------------------------------------------------------------
  /// JS → Dart 브리지
  /// ---------------------------------------------------------------------------
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
      _handleErrorCode(parsed.errorCode, parsed.errorDetail);
    }

    if (type == KakaoMapEventType.error &&
        (parsed.errorCode?.toLowerCase().contains('sdkfail') ?? false)) {
      final detail =
          parsed.errorDetail ?? parsed.logMessage ?? 'sdkFail detected';
      _pushDebugLog(
        '[sdkFail] $detail (attempt: $_reloadAttempts)',
        level: 'error',
      );
    }

    _eventController.add(event);
  }

  void _handleErrorCode(String? code, [String? detail]) {
    if (code == null) return;
    final lower = code.toLowerCase();
    if (_reloadAttempts >= maxAutoReloads) {
      _pushDebugLog('Kakao map reload limit reached for $code');
      return;
    }

    if (lower.contains('sdkfail') || lower.contains('timeout')) {
      final delay = Duration(milliseconds: 500 * (_reloadAttempts + 1));
      _reloadAttempts += 1;
      _pushDebugLog(
        'Retrying map load for $code in ${delay.inMilliseconds}ms. detail=${detail ?? 'n/a'}',
        level: 'warn',
      );
      Future.delayed(delay, () {
        if (_lastLoadRequest != null) {
          load(
            center: _lastLoadRequest!.center,
            markers: _lastLoadRequest!.markers,
            polylines: _lastLoadRequest!.polylines,
            options: _lastLoadRequest!.options,
            enableClustering: _lastLoadRequest!.enableClustering,
            additionalScripts: _lastLoadRequest!.additionalScripts,
          );
        } else {
          webViewController.reload();
        }
      });
    }
  }

  KakaoMapEventType _mapType(String? raw) {
    switch (raw) {
      case 'ready':
        return KakaoMapEventType.ready;
      case 'marker':
        return KakaoMapEventType.markerTap;
      case 'onMarkerClicked':
        return KakaoMapEventType.markerClicked;
      case 'map':
        return KakaoMapEventType.mapTap;
      case 'cluster':
        return KakaoMapEventType.clusterTap;
      case 'map_move':
        return KakaoMapEventType.mapMove;
      case 'centerMarkerClick':
        return KakaoMapEventType.markerClicked;
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
      case 'bootstrap':
      case 'mapReady':
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

  void _pushDebugLog(String message, {String level = 'info'}) {
    final logMessage = KakaoMapMessage(
      type: 'log',
      payload: {'message': message},
      logLevel: level,
      raw: message,
      timestamp: DateTime.now(),
      origin: 'kakao-map-controller',
    );
    _eventController.add(KakaoMapEvent(KakaoMapEventType.log, logMessage));
  }

  void dispose() {
    _eventController.close();
    _pendingActions.clear();
  }
}
