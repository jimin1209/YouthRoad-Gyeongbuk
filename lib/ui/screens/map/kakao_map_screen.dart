import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../application/providers.dart';
import '../../../core/constants/env.dart';
import '../../../domain/entities/policy.dart';
import '../../widgets/app_appbar.dart';
import 'kakao_map_html_builder.dart';

class KakaoMapScreen extends ConsumerStatefulWidget {
  const KakaoMapScreen({super.key});

  @override
  ConsumerState<KakaoMapScreen> createState() => _KakaoMapScreenState();
}

class _KakaoMapScreenState extends ConsumerState<KakaoMapScreen> {
  static const _htmlBuilder = KakaoMapHtmlBuilder();
  late final WebViewController _controller;
  bool _isLoading = true;

  static const _defaultCenter = KakaoMapLatLng(35.8714, 128.6014); // Daegu
  static const _mockPolicies = <KakaoMapPolicyMarker>[
    KakaoMapPolicyMarker(
      id: 'mock-1',
      title: '청년 취업 지원',
      lat: 35.872,
      lng: 128.602,
    ),
    KakaoMapPolicyMarker(
      id: 'mock-2',
      title: '창업 보육 프로그램',
      lat: 35.876,
      lng: 128.61,
    ),
    KakaoMapPolicyMarker(
      id: 'mock-3',
      title: '주거 지원 시범사업',
      lat: 35.868,
      lng: 128.595,
    ),
    KakaoMapPolicyMarker(
      id: 'mock-4',
      title: '문화 체험 바우처',
      lat: 35.865,
      lng: 128.59,
    ),
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

  List<KakaoMapPolicyMarker> _policyMarkers(
    KakaoMapLatLng center,
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
      return KakaoMapPolicyMarker(
        id: policy.id,
        title: policy.title,
        lat: offset.lat,
        lng: offset.lng,
      );
    });
  }

  List<KakaoMapLatLng> _markerOffsets(KakaoMapLatLng base) {
    const deltas = <KakaoMapLatLng>[
      KakaoMapLatLng(0, 0),
      KakaoMapLatLng(0.005, 0.003),
      KakaoMapLatLng(-0.003, 0.006),
      KakaoMapLatLng(0.006, -0.004),
      KakaoMapLatLng(-0.005, -0.002),
      KakaoMapLatLng(0.002, 0.007),
    ];

    return deltas
        .map(
          (delta) => KakaoMapLatLng(base.lat + delta.lat, base.lng + delta.lng),
        )
        .toList();
  }

  KakaoMapLatLng _centerFromRegion(String? region) {
    if (region == null || region.isEmpty) {
      return _defaultCenter;
    }
    final normalized = region.replaceAll(' ', '');
    if (normalized.contains('경상북')) {
      return const KakaoMapLatLng(36.4919, 128.8889);
    }
    if (normalized.contains('대구')) {
      return const KakaoMapLatLng(35.8714, 128.6014);
    }
    return _defaultCenter;
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
