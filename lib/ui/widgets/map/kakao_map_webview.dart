import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controllers/map/kakao_map_controller.dart';
import '../../providers/map/kakao_map_providers.dart';
import '../../screens/map/kakao_map_html_builder.dart';

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
    this.onMapTap,
    this.onReady,
    this.onLoadingChanged,
    this.onError,
  });

  final KakaoMapLatLng center;
  final List<KakaoMapMarker> markers;
  final List<KakaoMapPolyline> polylines;
  final bool enableClustering;
  final KakaoMapOptions options;
  final String? additionalScripts;
  final void Function(String markerId)? onMarkerTap;
  final void Function(KakaoMapLatLng position)? onMapTap;
  final VoidCallback? onReady;
  final void Function(bool isLoading)? onLoadingChanged;
  final void Function(String code)? onError;

  @override
  ConsumerState<KakaoMapWebView> createState() => _KakaoMapWebViewState();
}

class _KakaoMapWebViewState extends ConsumerState<KakaoMapWebView> {
  late final KakaoMapController _controller;
  StreamSubscription<KakaoMapEvent>? _eventSub;
  bool _loading = true;
  bool _fatalError = false;
  int _errorCount = 0;
  ProviderSubscription<KakaoMapController>? _controllerSubscription;
  KakaoMapOptions? _lastOptions;
  bool? _lastClustering;
  Timer? _readyTimeout;
  static const _readyTimeoutDuration = Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    _controller = ref.read(kakaoMapControllerProvider);
    _controllerSubscription = ref.listenManual<KakaoMapController>(
      kakaoMapControllerProvider,
      (_, __) {},
    );
    _eventSub = _controller.events.listen(_handleEvent);
    _loadMap();
  }

  @override
  void didUpdateWidget(covariant KakaoMapWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.center != oldWidget.center) {
      _controller.animateTo(widget.center);
    }
    if (!_markersEqual(widget.markers, oldWidget.markers)) {
      _controller.setMarkers(widget.markers);
    }
    if (!_polylinesEqual(widget.polylines, oldWidget.polylines)) {
      _controller.setPolylines(widget.polylines);
    }
    if (widget.enableClustering != _lastClustering || widget.options != _lastOptions) {
      _loadMap();
    }
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    _controllerSubscription?.close();
    _readyTimeout?.cancel();
    super.dispose();
  }

  void _loadMap() {
    _lastOptions = widget.options;
    _lastClustering = widget.enableClustering;
    _fatalError = false;
    _errorCount = 0;
    _notifyLoading(true);
    _scheduleReadyTimeout();
    _controller.load(
      center: widget.center,
      markers: widget.markers,
      polylines: widget.polylines,
      options: widget.options,
      enableClustering: widget.enableClustering,
      additionalScripts: widget.additionalScripts,
    );
  }

  void _handleEvent(KakaoMapEvent event) {
    switch (event.type) {
      case KakaoMapEventType.ready:
        _errorCount = 0;
        _fatalError = false;
        _readyTimeout?.cancel();
        _notifyLoading(false);
        widget.onReady?.call();
        break;
      case KakaoMapEventType.loading:
        _notifyLoading(event.loadingValue);
        break;
      case KakaoMapEventType.markerTap:
        final markerId = event.markerId;
        if (markerId != null) {
          widget.onMarkerTap?.call(markerId);
        }
        break;
      case KakaoMapEventType.mapTap:
      case KakaoMapEventType.clusterTap:
        final position = event.position;
        if (position != null) {
          widget.onMapTap?.call(position);
        }
        break;
      case KakaoMapEventType.error:
        _notifyLoading(false);
        _errorCount += 1;
        if (_errorCount > 2) {
          setState(() {
            _fatalError = true;
          });
        }
        final code = event.errorCode ?? 'unknown';
        widget.onError?.call(code);
        break;
      case KakaoMapEventType.mapType:
      case KakaoMapEventType.log:
      case KakaoMapEventType.unknown:
        break;
    }
  }

  void _notifyLoading(bool value) {
    if (_loading == value) return;
    setState(() {
      _loading = value;
    });
    widget.onLoadingChanged?.call(value);
  }

  void _scheduleReadyTimeout() {
    _readyTimeout?.cancel();
    _readyTimeout = Timer(_readyTimeoutDuration, () {
      if (mounted && !_controller.isReady) {
        setState(() {
          _fatalError = true;
          _loading = false;
        });
        widget.onError?.call('READY_TIMEOUT');
      }
    });
  }

  bool _markersEqual(List<KakaoMapMarker> a, List<KakaoMapMarker> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _polylinesEqual(List<KakaoMapPolyline> a, List<KakaoMapPolyline> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
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
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (_fatalError)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        '지도를 불러오지 못했습니다. 다시 시도해주세요.',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _fatalError = false;
                          _loading = true;
                        });
                        _controller.reloadMap();
                      },
                      child: const Text('다시 시도'),
                    )
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
