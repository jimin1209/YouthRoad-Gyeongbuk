import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../application/providers.dart';
import '../../../core/constants/env.dart';
import '../../../domain/entities/policy.dart';
import '../../widgets/app_appbar.dart';

class KakaoMapScreen extends ConsumerStatefulWidget {
  const KakaoMapScreen({super.key});

  @override
  ConsumerState<KakaoMapScreen> createState() => _KakaoMapScreenState();
}

class _KakaoMapScreenState extends ConsumerState<KakaoMapScreen> {
  static const _htmlBuilder = _KakaoMapHtmlBuilder();
  late final WebViewController _controller;
  bool _isLoading = true;

  static const _defaultCenter = _LatLng(35.8714, 128.6014); // Daegu
  static const _mockPolicies = <_PolicyMarker>[
    _PolicyMarker(title: '청년 취업 지원', lat: 35.872, lng: 128.602),
    _PolicyMarker(title: '창업 보육 프로그램', lat: 35.876, lng: 128.61),
    _PolicyMarker(title: '주거 지원 시범사업', lat: 35.868, lng: 128.595),
    _PolicyMarker(title: '문화 체험 바우처', lat: 35.865, lng: 128.59),
  ];

  @override
  void initState() {
    super.initState();
    final center = _centerFromRegion(ref.read(regionProvider));
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadHtmlString(
        _htmlBuilder.build(
          apiKey: Env.kakaoMapApiKey,
          center: center,
          markers: _policyMarkers(center, ref.read(policyListNotifierProvider)),
        ),
      );

    ref.listen<String?>(regionProvider, (_, __) {
      _reloadMap();
    });

    ref.listen<AsyncValue<List<Policy>>>(policyListNotifierProvider, (prev, next) {
      if (next.hasValue && next.valueOrNull != prev?.valueOrNull) {
        _reloadMap();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: '카카오맵 보기'),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _reloadMap() {
    final center = _centerFromRegion(ref.read(regionProvider));
    final markers = _policyMarkers(center, ref.read(policyListNotifierProvider));

    setState(() {
      _isLoading = true;
    });

    _controller.loadHtmlString(
      _htmlBuilder.build(
        apiKey: Env.kakaoMapApiKey,
        center: center,
        markers: markers,
      ),
    );
  }

  List<_PolicyMarker> _policyMarkers(
    _LatLng center,
    AsyncValue<List<Policy>> asyncPolicies,
  ) {
    final policies = asyncPolicies.valueOrNull;
    if (policies == null || policies.isEmpty) {
      return _mockPolicies;
    }

    final markerOffsets = _markerOffsets(center);
    final limitedPolicies = policies.take(markerOffsets.length).toList();

    return List.generate(limitedPolicies.length, (index) {
      final policy = limitedPolicies[index];
      final offset = markerOffsets[index];
      return _PolicyMarker(
        title: policy.title,
        lat: offset.lat,
        lng: offset.lng,
      );
    });
  }

  List<_LatLng> _markerOffsets(_LatLng base) {
    const deltas = <_LatLng>[
      _LatLng(0, 0),
      _LatLng(0.005, 0.003),
      _LatLng(-0.003, 0.006),
      _LatLng(0.006, -0.004),
      _LatLng(-0.005, -0.002),
      _LatLng(0.002, 0.007),
    ];

    return deltas
        .map((delta) => _LatLng(base.lat + delta.lat, base.lng + delta.lng))
        .toList();
  }

  _LatLng _centerFromRegion(String? region) {
    if (region == null || region.isEmpty) {
      return _defaultCenter;
    }
    final normalized = region.replaceAll(' ', '');
    if (normalized.contains('경상북')) {
      return const _LatLng(36.4919, 128.8889);
    }
    if (normalized.contains('대구')) {
      return const _LatLng(35.8714, 128.6014);
    }
    return _defaultCenter;
  }
}

class _KakaoMapHtmlBuilder {
  const _KakaoMapHtmlBuilder();

  String build({
    required String apiKey,
    required _LatLng center,
    required List<_PolicyMarker> markers,
  }) {
    if (apiKey.isEmpty) {
      return _missingApiKeyPage();
    }

    final markerJson = markers
        .map(
          (m) => "{title: '${m.title.replaceAll("'", "\\'")}', lat: ${m.lat}, lng: ${m.lng}}",
        )
        .join(',');

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
  <style>
    html, body, #map { width: 100%; height: 100%; margin: 0; padding: 0; }
  </style>
  <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=$apiKey&autoload=false"></script>
</head>
<body>
  <div id="map"></div>
  <script>
    kakao.maps.load(function() {
      var container = document.getElementById('map');
      var options = {
        center: new kakao.maps.LatLng(${center.lat}, ${center.lng}),
        level: 6
      };
      var map = new kakao.maps.Map(container, options);

      var markers = [$markerJson];
      markers.forEach(function(m) {
        var position = new kakao.maps.LatLng(m.lat, m.lng);
        var marker = new kakao.maps.Marker({ position: position });
        marker.setMap(map);

        var infoWindow = new kakao.maps.InfoWindow({
          content: '<div style="padding:8px;font-size:13px;">' + m.title + '</div>'
        });
        kakao.maps.event.addListener(marker, 'click', function() {
          infoWindow.open(map, marker);
        });
      });
    });
  </script>
</body>
</html>
''';
  }

  String _missingApiKeyPage() {
    return '''
<!DOCTYPE html>
<html>
<body>
  <p style="padding:16px;font-size:16px;">
    카카오맵 API 키가 설정되지 않았습니다. KAKAO_MAP_API_KEY 환경 변수를 추가해주세요.
  </p>
</body>
</html>
''';
  }
}

class _LatLng {
  const _LatLng(this.lat, this.lng);

  final double lat;
  final double lng;
}

class _PolicyMarker {
  const _PolicyMarker({required this.title, required this.lat, required this.lng});

  final String title;
  final double lat;
  final double lng;
}
