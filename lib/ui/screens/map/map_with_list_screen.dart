import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../application/notifiers/policy_list_notifier.dart';
import '../../../application/providers.dart';
import '../../../core/constants/env.dart';
import '../../../domain/entities/policy.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/policy_card_v2.dart';
import '../../widgets/global_error_view.dart';
import 'kakao_map_html_builder.dart';

class MapWithListScreen extends ConsumerStatefulWidget {
  const MapWithListScreen({super.key});

  @override
  ConsumerState<MapWithListScreen> createState() => _MapWithListScreenState();
}

class _MapWithListScreenState extends ConsumerState<MapWithListScreen> {
  static const _htmlBuilder = KakaoMapHtmlBuilder();
  static const _bridgeName = 'MapBridge';
  static const _estimatedItemHeight = 220.0;

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

  late final ScrollController _listController;
  late final WebViewController _mapController;
  bool _isLoading = true;
  bool _mapReady = false;
  bool _isMapUpdating = false;
  bool _isRegionUpdating = false;
  String? _selectedPolicyId;
  Map<String, KakaoMapPolicyMarker> _markerLookup = {};

  @override
  void initState() {
    super.initState();
    _listController = ScrollController()..addListener(_onListScroll);
    _initWebView();
  }

  @override
  void dispose() {
    _listController.removeListener(_onListScroll);
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(regionProvider, (_, __) {
      _reloadMap();
    });

    ref.listen<AsyncValue<List<Policy>>>(policyListNotifierProvider, (prev, next) {
      if (next.hasValue && next.valueOrNull != prev?.valueOrNull) {
        _reloadMap();
      }
    });

    final policies = ref.watch(policyListNotifierProvider);
    return Scaffold(
      appBar: const AppAppBar(title: '지도 + 리스트'),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  WebViewWidget(controller: _mapController),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
            Expanded(
              child: policies.when(
                data: (data) => ListView.separated(
                  controller: _listController,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (_, i) {
                    final policy = data[i];
                    return PolicyCardV2(
                      policy: policy,
                      onTap: () => _onPolicyTap(policy),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: data.length,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => GlobalErrorView(
                  message: PolicyListNotifier.errorMessage,
                  onRetry: () {
                    ref.invalidate(policyListNotifierProvider);
                    ref.read(policyListNotifierProvider); // trigger reload
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initWebView() {
    _mapController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        _bridgeName,
        onMessageReceived: _onMapEvent,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      );

    _reloadMap();
  }

  void _reloadMap() {
    final center = _centerFromRegion(ref.read(regionProvider));
    final markers = _policyMarkers(center, ref.read(policyListNotifierProvider));
    _markerLookup = {for (final marker in markers) marker.id: marker};

    setState(() {
      _isLoading = true;
      _mapReady = false;
    });

    _mapController.loadHtmlString(
      _htmlBuilder.build(
        apiKey: Env.kakaoMapApiKey,
        center: center,
        markers: markers,
        bridgeName: _bridgeName,
      ),
    );
  }

  void _onPolicyTap(Policy policy) {
    _selectedPolicyId = policy.id;
    _moveMapToPolicy(policy.id);
  }

  void _moveMapToPolicy(String policyId) {
    if (!_mapReady) return;
    final marker = _markerLookup[policyId];
    if (marker == null) return;
    final script = 'moveTo(${marker.lat}, ${marker.lng});';
    _mapController.runJavaScript(script);
  }

  void _onListScroll() {
    if (_isMapUpdating || !_mapReady) return;
    if (!_listController.hasClients) return;

    final policies = ref.read(policyListNotifierProvider).valueOrNull;
    if (policies == null || policies.isEmpty) return;

    final index = (_listController.offset / _estimatedItemHeight)
        .floor()
        .clamp(0, policies.length - 1);
    final current = policies[index];
    if (current.id == _selectedPolicyId) return;
    _selectedPolicyId = current.id;
    _moveMapToPolicy(current.id);
  }

  void _onMapEvent(JavaScriptMessage message) {
    final content = message.message;
    if (content == 'ready') {
      setState(() {
        _mapReady = true;
        _isLoading = false;
      });
      return;
    }
    if (content.startsWith('marker:')) {
      final markerId = content.replaceFirst('marker:', '');
      _highlightPolicy(markerId);
      return;
    }
    if (content.startsWith('region:')) {
      final coords = content.replaceFirst('region:', '').split(',');
      if (coords.length == 2) {
        final lat = double.tryParse(coords[0]);
        final lng = double.tryParse(coords[1]);
        if (lat != null && lng != null) {
          _updateRegionFilter(lat, lng);
          _highlightNearestPolicy(lat, lng);
        }
      }
    }
  }

  void _highlightPolicy(String policyId) {
    final policies = ref.read(policyListNotifierProvider).valueOrNull;
    if (policies == null) return;
    final index = policies.indexWhere((p) => p.id == policyId);
    if (index == -1) return;

    _selectedPolicyId = policyId;
    _isMapUpdating = true;
    if (_listController.hasClients) {
      final targetOffset = (index * _estimatedItemHeight)
          .clamp(0, _listController.position.maxScrollExtent);
      _listController.animateTo(
        targetOffset.toDouble(),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    Future.delayed(const Duration(milliseconds: 350), () {
      _isMapUpdating = false;
    });
  }

  void _highlightNearestPolicy(double lat, double lng) {
    if (_markerLookup.isEmpty) return;
    final nearest = _markerLookup.values.reduce((a, b) {
      final distA = _distance(lat, lng, a.lat, a.lng);
      final distB = _distance(lat, lng, b.lat, b.lng);
      return distA <= distB ? a : b;
    });
    _highlightPolicy(nearest.id);
  }

  void _updateRegionFilter(double lat, double lng) {
    if (_isRegionUpdating) return;
    final current = ref.read(regionProvider);
    final region = _regionNameFromLatLng(lat, lng);
    if (region == null || region == current) return;
    _isRegionUpdating = true;
    ref.read(regionProvider.notifier).select(region);
    Future.delayed(const Duration(milliseconds: 200), () {
      _isRegionUpdating = false;
    });
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

  String? _regionNameFromLatLng(double lat, double lng) {
    if (lat >= 36.2) {
      return '경상북도';
    }
    if (lat >= 35.7 && lng >= 128.4 && lng <= 128.9) {
      return '대구광역시';
    }
    return null;
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
        title: policy.policyNm,
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

  double _distance(double lat1, double lng1, double lat2, double lng2) {
    final dx = lat1 - lat2;
    final dy = lng1 - lng2;
    return sqrt(dx * dx + dy * dy);
  }
}
