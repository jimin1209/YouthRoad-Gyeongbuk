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
    this.onMarkerTap,
    this.onMapTap,
    this.onReady,
    this.onLoadingChanged,
  });

  final KakaoMapLatLng center;
  final List<KakaoMapMarker> markers;
  final void Function(String markerId)? onMarkerTap;
  final void Function(KakaoMapLatLng position)? onMapTap;
  final VoidCallback? onReady;
  final void Function(bool isLoading)? onLoadingChanged;

  @override
  ConsumerState<KakaoMapWebView> createState() => _KakaoMapWebViewState();
}

class _KakaoMapWebViewState extends ConsumerState<KakaoMapWebView> {
  late final KakaoMapController _controller;
  StreamSubscription<KakaoMapEvent>? _eventSub;
  bool _loading = true;
  ProviderSubscription<KakaoMapController>? _controllerSubscription;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(kakaoMapControllerProvider);
    _controllerSubscription = ref.listenManual<KakaoMapController>(
      kakaoMapControllerProvider,
      (_, __) {},
    );
    _eventSub = _controller.events.listen(_handleEvent);
    _controller.load(center: widget.center, markers: widget.markers);
  }

  @override
  void didUpdateWidget(covariant KakaoMapWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.center != oldWidget.center) {
      _controller.moveTo(widget.center);
    }
    if (!_listEquals(widget.markers, oldWidget.markers)) {
      _controller.setMarkers(widget.markers);
    }
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    _controllerSubscription?.close();
    super.dispose();
  }

  void _handleEvent(KakaoMapEvent event) {
    switch (event.type) {
      case KakaoMapEventType.ready:
        _notifyLoading(false);
        widget.onReady?.call();
        break;
      case KakaoMapEventType.markerTap:
        final markerId = event.markerId;
        if (markerId != null) {
          widget.onMarkerTap?.call(markerId);
        }
        break;
      case KakaoMapEventType.mapTap:
        final position = event.position;
        if (position != null) {
          widget.onMapTap?.call(position);
        }
        break;
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

  bool _listEquals(List<KakaoMapMarker> a, List<KakaoMapMarker> b) {
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
      ],
    );
  }
}
