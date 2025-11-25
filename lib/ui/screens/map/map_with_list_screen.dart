import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../application/notifiers/policy_list_notifier.dart';
import '../../../application/providers.dart';
import '../../../core/constants/env.dart';
import '../../../domain/entities/policy.dart';
import '../../../navigation/route_paths.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/global_error_view.dart';
import '../../widgets/policy_card_v2.dart';
import 'kakao_map_html_builder.dart';

class MapWithListScreen extends ConsumerStatefulWidget {
  const MapWithListScreen({super.key});

  @override
  ConsumerState<MapWithListScreen> createState() => _MapWithListScreenState();
}

class _MapWithListScreenState extends ConsumerState<MapWithListScreen> {
  static const _htmlBuilder = KakaoMapHtmlBuilder();
  static const _bridgeName = 'MapBridge';
  static const _estimatedItemHeight = 240.0;
  static const _defaultCenter = KakaoMapLatLng(36.4919, 128.8889);

  late final ScrollController _listController;
  late final WebViewController _mapController;
  ProviderSubscription<String?>? _regionSubscription;
  ProviderSubscription<AsyncValue<List<Policy>>>? _policySubscription;
  bool _isLoading = true;
  bool _mapReady = false;
  bool _isMapUpdating = false;
  String? _selectedPolicyId;
  String? _lastMarkerTapId;
  Map<String, KakaoMapPolicyMarker> _markerLookup = {};

  @override
  void initState() {
    super.initState();
    _listController = ScrollController()..addListener(_onListScroll);
    _setupListeners();
    _initWebView();
  }

  @override
  void dispose() {
    _listController.removeListener(_onListScroll);
    _listController.dispose();
    _regionSubscription?.close();
    _policySubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final policies = ref.watch(policyListNotifierProvider);
    return Scaffold(
      appBar: const AppAppBar(title: '지도 + 리스트'),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 240,
              child: Stack(
                children: [
                  WebViewWidget(controller: _mapController),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 12,
                    child: _buildOverlay(policies),
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
                    ref.read(policyListNotifierProvider);
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
          onPageStarted: (_) => setState(() {
            _isLoading = true;
            _mapReady = false;
          }),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      );

    _reloadMap();
  }

  void _setupListeners() {
    _regionSubscription =
        ref.listenManual<String?>(regionProvider, (_, __) => _reloadMap());
    _policySubscription = ref.listenManual<AsyncValue<List<Policy>>>(
      policyListNotifierProvider,
      (prev, next) {
        if (next.hasValue && next.valueOrNull != prev?.valueOrNull) {
          _reloadMap();
        }
      },
    );
  }

  void _reloadMap() {
    final center = _centerForRegion(ref.read(regionProvider));
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

  Widget _buildOverlay(AsyncValue<List<Policy>> policies) {
    return policies.when(
      data: (_) => const SizedBox.shrink(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.65),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '정책을 불러오지 못했습니다.',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _onPolicyTap(Policy policy) {
    _selectedPolicyId = policy.id;
    _moveMapToPolicy(policy.id);
    context.push(RoutePaths.policyDetail(policy.id));
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
      if (_lastMarkerTapId == markerId) {
        context.push(RoutePaths.policyDetail(markerId));
        return;
      }
      _lastMarkerTapId = markerId;
      _highlightPolicy(markerId);
    }
    if (content.startsWith('region:')) {
      final coords = content.replaceFirst('region:', '').split(',');
      if (coords.length == 2) {
        final lat = double.tryParse(coords[0]);
        final lng = double.tryParse(coords[1]);
        if (lat != null && lng != null) {
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

  KakaoMapLatLng _centerForRegion(String? regionName) {
    final normalized = (regionName ?? '').trim();
    switch (normalized) {
      case '포항시':
        return const KakaoMapLatLng(36.0190, 129.3435);
      case '구미시':
        return const KakaoMapLatLng(36.1195, 128.3446);
      case '경산시':
        return const KakaoMapLatLng(35.8252, 128.7415);
      case '안동시':
        return const KakaoMapLatLng(36.5684, 128.7294);
      case '김천시':
        return const KakaoMapLatLng(36.1398, 128.1136);
      case '경북 전체':
        return _defaultCenter;
      default:
        if (normalized.isEmpty) return _defaultCenter;
        return _defaultCenter;
    }
  }

  List<KakaoMapPolicyMarker> _policyMarkers(
    KakaoMapLatLng center,
    AsyncValue<List<Policy>> asyncPolicies,
  ) {
    final policies = asyncPolicies.valueOrNull;
    if (policies == null || policies.isEmpty) return const [];

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
