import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/map/kakao_map_models.dart';
import '../../models/map/kakao_map_options.dart';
import '../map/kakao_map_commands.dart';
import '../../screens/map/kakao_map_html_builder.dart';

enum KakaoMapStatus {
  loading,
  sdkLoading,
  sdkLoaded,
  ready,
  error,
  reloading,
}

class KakaoMapController {
  KakaoMapController({
    required this.apiKey,
    required KakaoMapOptions initialOptions,
    this.bridgeName = 'KakaoMapBridge',
    KakaoMapHtmlBuilder? htmlBuilder,
  })  : _options = initialOptions,
        _htmlBuilder = htmlBuilder ?? const KakaoMapHtmlBuilder();

  final String apiKey;
  final String bridgeName;
  KakaoMapOptions _options;
  final KakaoMapHtmlBuilder _htmlBuilder;
  final _eventController = StreamController<KakaoMapEvent>.broadcast();
  final _commandQueue = <KakaoMapCommand>[];
  WebViewController? _webViewController;
  KakaoMapStatus status = KakaoMapStatus.loading;
  String? lastError;

  Stream<KakaoMapEvent> get events => _eventController.stream;
  KakaoMapOptions get options => _options;

  Future<String> buildHtml() async {
    return _htmlBuilder.build(
      apiKey: apiKey,
      options: _options,
      bridgeName: bridgeName,
    );
  }

  void attachWebViewController(WebViewController controller) {
    _webViewController = controller;
  }

  void handleMessage(String message) {
    try {
      final event = KakaoMapEvent.fromJsonString(message);
      _syncStatus(event.type);
      _eventController.add(event);
      if (event.type == KakaoMapEventType.ready) {
        _flushQueue();
      }
    } catch (e, stack) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('[KakaoMapController] Failed to parse message: $e\n$stack');
      }
    }
  }

  void _syncStatus(KakaoMapEventType type) {
    switch (type) {
      case KakaoMapEventType.sdkLoading:
        status = KakaoMapStatus.sdkLoading;
        break;
      case KakaoMapEventType.sdkLoaded:
        status = KakaoMapStatus.sdkLoaded;
        break;
      case KakaoMapEventType.ready:
        status = KakaoMapStatus.ready;
        break;
      case KakaoMapEventType.error:
      case KakaoMapEventType.sdkFailed:
        status = KakaoMapStatus.error;
        break;
      default:
        break;
    }
  }

  Future<KakaoMapCommandResult> sendCommand(KakaoMapCommand command) async {
    if (status != KakaoMapStatus.ready) {
      _commandQueue.add(command);
      return const KakaoMapCommandResult(success: true, message: 'Queued');
    }
    return _evaluateCommand(command);
  }

  Future<KakaoMapCommandResult> _evaluateCommand(
    KakaoMapCommand command,
  ) async {
    final controller = _webViewController;
    if (controller == null) {
      return const KakaoMapCommandResult(success: false, message: 'WebView not attached');
    }

    final jsonCommand = jsonEncode(command.toJson());
    final script = 'window.handleKakaoCommand($jsonCommand);';
    try {
      await controller.runJavaScript(script);
      return const KakaoMapCommandResult(success: true);
    } catch (e) {
      return KakaoMapCommandResult(success: false, message: e.toString());
    }
  }

  Future<void> _flushQueue() async {
    if (_commandQueue.isEmpty) return;
    final pending = List<KakaoMapCommand>.from(_commandQueue);
    _commandQueue.clear();
    for (final command in pending) {
      await _evaluateCommand(command);
    }
  }

  Future<KakaoMapCommandResult> moveTo(KakaoMapLatLng center, {bool animate = false}) {
    _options = _options.copyWith(center: center);
    return sendCommand(SetCenterCommand(center, animate: animate));
  }

  Future<KakaoMapCommandResult> setLevel(int level) {
    _options = _options.copyWith(level: level);
    return sendCommand(SetLevelCommand(level));
  }

  Future<KakaoMapCommandResult> setMapType(KakaoMapMapType mapType) {
    _options = _options.copyWith(mapType: mapType);
    return sendCommand(SetMapTypeCommand(mapType));
  }

  Future<KakaoMapCommandResult> setMarkers(List<KakaoMapMarker> markers) {
    _options = _options.copyWith(markers: markers);
    return sendCommand(SetMarkersCommand(markers));
  }

  Future<KakaoMapCommandResult> setPolylines(List<KakaoMapPolyline> polylines) {
    _options = _options.copyWith(polylines: polylines);
    return sendCommand(SetPolylinesCommand(polylines));
  }

  Future<KakaoMapCommandResult> fitToMarkers() {
    return sendCommand(FitToMarkersCommand(_options.markers));
  }

  Future<KakaoMapCommandResult> reload() {
    status = KakaoMapStatus.reloading;
    _commandQueue.clear();
    final options = _options;
    return sendCommand(ReloadCommand(options));
  }

  void markLoading() {
    status = KakaoMapStatus.loading;
  }

  void markError(String message) {
    status = KakaoMapStatus.error;
    lastError = message;
  }

  void dispose() {
    _eventController.close();
    _commandQueue.clear();
  }
}
