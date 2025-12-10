import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'kakao_map_controller.dart';
import 'kakao_map_html_builder.dart';
import 'kakao_map_providers.dart';

class KakaoMapWebView extends ConsumerStatefulWidget {
  const KakaoMapWebView({
    super.key,
    required this.center,
    required this.markers,
    this.polylines = const [],
    this.enableClustering = false,
    this.options = const KakaoMapOptions(),
    this.additionalScripts,
    this.onMarkerTap,
    this.onMarkerClicked,
    this.onMapTap,
    this.onMapMoved,
    this.onReady,
    this.onLoadingChanged,
    this.onError,
    this.onLog,
    this.showDebugPanel = false,
    this.radiusKm = 20.0,
  });

  final KakaoMapLatLng center;
  final List<KakaoMapMarker> markers;
  final List<KakaoMapPolyline> polylines;
  final bool enableClustering;
  final KakaoMapOptions options;
  final String? additionalScripts;

  final void Function(String markerId)? onMarkerTap;
  final void Function(String markerId, Map<String, dynamic>? extra)?
      onMarkerClicked;
  final void Function(KakaoMapLatLng position)? onMapTap;
  final void Function(KakaoMapLatLng center, int zoom)? onMapMoved;
  final VoidCallback? onReady;
  final void Function(bool isLoading)? onLoadingChanged;
  final void Function(String code)? onError;
  final void Function(KakaoMapEvent logEvent)? onLog;
  final bool showDebugPanel;
  final double radiusKm;

  @override
  ConsumerState<KakaoMapWebView> createState() => _KakaoMapWebViewState();
}

class _KakaoMapWebViewState extends ConsumerState<KakaoMapWebView> {
  late final KakaoMapController _controller;

  StreamSubscription<KakaoMapEvent>? _eventSub;
  Timer? _readyTimeout;

  bool _loading = true;
  bool _fatalError = false;
  int _errorCount = 0;

  final List<KakaoMapEvent> _logs = [];
  static const _readyTimeoutDuration = Duration(seconds: 20);

  bool get _isSafeToUpdateUI =>
      SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle;

  @override
  void initState() {
    super.initState();

    _controller = ref.read(kakaoMapControllerProvider);
    _eventSub = _controller.events.listen(_handleEvent);

    _safeLog('WebView init()');
    _loadMap();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (_loading) {
        _safeLog('fallback: force loading=false after 3s');
        _safeSetLoading(false);
      }
    });
  }

  @override
  void didUpdateWidget(covariant KakaoMapWebView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.center != oldWidget.center) {
      _controller.animateTo(widget.center);
    }

    if (!_listEquals(widget.markers, oldWidget.markers)) {
      _controller.setMarkers(widget.markers);
    }

    if (!_listEquals(widget.polylines, oldWidget.polylines)) {
      _controller.setPolylines(widget.polylines);
    }
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    _readyTimeout?.cancel();
    super.dispose();
  }

  void _loadMap() {
    _fatalError = false;
    _errorCount = 0;
    _safeSetLoading(true);

    _scheduleReadyTimeout();
    _safeLog(
      '[Map][INFO] map load start center=(${widget.center.lat}, ${widget.center.lng}), key=${_controller.apiKeyPreview}',
    );

    final basePosition = _controller.basePosition ?? widget.center;

    if (!_controller.hasApiKey) {
      _safeLog('[Map][ERROR] KakaoMap API Key 가 없습니다. --dart-define 설정을 확인하세요.');
      _safeSetLoading(false);
      _safeMarkFatalError();
      _safeCallback(() => widget.onError?.call('API_KEY_EMPTY'));
      return;
    }

    _controller
        .load(
      center: widget.center,
      basePosition: basePosition,
      markers: widget.markers,
      polylines: widget.polylines,
      options: widget.options,
      enableClustering: widget.enableClustering,
      additionalScripts: widget.additionalScripts,
      searchRadiusMeters: widget.radiusKm * 1000,
    )
        .then((_) {
      if (!mounted) return;
      if (_loading) {
        _safeLog('load() completed, force loading=false (html injected)');
        _safeSetLoading(false);
      }
    }).catchError((error, stack) {
      _safeLog('load() error: $error');
      _safeSetLoading(false);
      _safeMarkFatalError();
      _safeCallback(() => widget.onError?.call('LOAD_ERROR'));
    });

    _controller.sendCenterUpdate(basePosition);
    _controller.sendCircleUpdate(
      center: basePosition,
      radiusMeters: widget.radiusKm * 1000,
    );
  }

  void _handleEvent(KakaoMapEvent event) {
    _pushLog(event);

    if (_loading && event.type != KakaoMapEventType.log) {
      _safeLog('event received (${event.type}) -> loading=false');
      _safeSetLoading(false);
    }

    final rawType = event.message.type;
    bool handledMarkerClicked = false;
    bool handledMapMove = false;

    if (rawType == 'marker') {
      final markerId = event.markerId;
      if (markerId != null) {
        handledMarkerClicked = true;
        _safeCallback(
          () => widget.onMarkerClicked?.call(markerId, event.extra),
        );
      }
    }

    if (rawType == 'map_move') {
      final position = event.position;
      if (position != null) {
        handledMapMove = true;
        final zoom = event.level ?? widget.options.level;
        _safeCallback(
          () => widget.onMapMoved?.call(position, zoom),
        );
      }
    }

    switch (event.type) {
      case KakaoMapEventType.ready:
        _safeLog('MAP_READY');
        _readyTimeout?.cancel();
        _safeSetLoading(false);
        _safeCallback(() => widget.onReady?.call());
        break;
      case KakaoMapEventType.markerTap:
        _safeCallback(() => widget.onMarkerTap?.call(event.markerId!));
        break;
      case KakaoMapEventType.markerClicked:
        if (!handledMarkerClicked) {
          final markerId = event.markerId;
          if (markerId != null) {
            _safeCallback(
              () => widget.onMarkerClicked?.call(markerId, event.extra),
            );
          }
        }
        break;
      case KakaoMapEventType.mapTap:
      case KakaoMapEventType.clusterTap:
        _safeCallback(() => widget.onMapTap?.call(event.position!));
        break;
      case KakaoMapEventType.mapMove:
        final position = event.position;
        if (position != null) {
          final zoom = event.level ?? widget.options.level;
          if (!handledMapMove) {
            _safeCallback(() => widget.onMapMoved?.call(position, zoom));
          }
        }
        break;
      case KakaoMapEventType.error:
        _errorCount++;
        _safeSetLoading(false);
        final code = event.errorCode ?? 'unknown';
        _safeLog('ERROR code=$code');
        _safeCallback(() => widget.onError?.call(code));
        if (_errorCount >= _controller.maxAutoReloads) {
          _safeMarkFatalError();
          return;
        }
        _controller.reloadMap();
        break;
      default:
        break;
    }
  }

  void _scheduleReadyTimeout() {
    _readyTimeout?.cancel();

    _readyTimeout = Timer(_readyTimeoutDuration, () {
      if (!_controller.isReady && mounted) {
        _safeMarkFatalError();
        _safeCallback(() => widget.onError?.call('READY_TIMEOUT'));
        _safeLog('READY_TIMEOUT');
        _safeSetLoading(false);
      }
    });
  }

  void _safeMarkFatalError() {
    _safeSetState(() => _fatalError = true);
  }

  void _safeSetLoading(bool value) {
    if (_loading == value) return;
    _safeSetState(() => _loading = value);
    _safeCallback(() => widget.onLoadingChanged?.call(value));
  }

  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;
    if (_isSafeToUpdateUI) {
      setState(fn);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(fn);
      });
    }
  }

  void _safeCallback(VoidCallback fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) fn();
    });
  }

  void _pushLog(KakaoMapEvent event) {
    _logs.add(event);
    if (_logs.length > 100) _logs.removeAt(0);
    _safeCallback(() => widget.onLog?.call(event));
  }

  void _safeLog(String msg) {
    final evt = KakaoMapEvent(
      KakaoMapEventType.log,
      KakaoMapMessage(
        type: 'info',
        payload: {'message': msg},
      ),
    );
    _pushLog(evt);
  }

  bool _listEquals(List a, List b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller.webViewController),
        if (_loading)
          Container(
            color: Colors.black12,
            child: const Center(child: CircularProgressIndicator()),
          ),
        if (_fatalError) _buildFatalErrorUI(),
      ],
    );
  }

  Widget _buildFatalErrorUI() {
    final last = _logs.isNotEmpty ? _logs.last : null;

    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Maps loading failed. Please try again.',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 6),
              if (last != null)
                Text(
                  last.message.payload['message']?.toString() ?? '',
                  style: const TextStyle(color: Colors.white60),
                ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadMap,
                child: const Text('Reload'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
