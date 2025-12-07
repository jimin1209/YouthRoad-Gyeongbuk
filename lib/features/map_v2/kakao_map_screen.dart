// lib/features/kakaomap/kakao_map_screen.dart

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../application/providers.dart';
import '../../debug/debug_settings_provider.dart';
import '../../navigation/route_paths.dart';
import '../../ui/widgets/app_appbar.dart';
import '../../env/app_env.dart';
import '../center/presentation/center_detail_bottom_sheet.dart';
import '../policy_new/data/mappers/youth_center_mapper.dart';
import '../policy_new/presentation/map/youth_center_map_provider.dart';
import 'kakao_map_html_builder.dart';
import 'kakao_map_providers.dart';
import 'kakao_map_webview.dart';
import 'services/gps_service.dart';
import 'services/location_permission_service.dart';
import '../../ui/components/app_common_bottom_sheets.dart';

// flutter run
//   --dart-define=YOUTH_CENTER_KEY=$YOUTH_CENTER_KEY
//   --dart-define=YOUTH_API_KEY=$YOUTH_API_KEY
//   --dart-define=KAKAO_MAP_API_KEY=$KAKAO_MAP_API_KEY
//   --dart-define=KAKAO_REST_API_KEY=$KAKAO_REST_API_KEY
//   --dart-define=CHAT_ENDPOINT=$CHAT_ENDPOINT

class KakaoMapScreen extends ConsumerStatefulWidget {
  const KakaoMapScreen({super.key});

  @override
  ConsumerState<KakaoMapScreen> createState() => _KakaoMapScreenState();
}

class _KakaoMapScreenState extends ConsumerState<KakaoMapScreen> {
  static final _defaultCenter = KakaoMapLatLng(36.4919, 128.8889);
  static const _debounceMs = 400;
  static const _gpsService = GpsService();
  static const _permissionService = LocationPermissionService();

  bool _loading = true;
  String? _errorCode;
  String? _lastLog;
  KakaoMapLatLng? _latestCenter;
  int? _latestZoom;
  CenterFetchRequest? _currentRequest;
  KakaoMapLatLng? _deviceLocation;
  bool _isRequestingLocation = false;
  String? _locationError;
  String? _centerMarkerIconBase64;
  Timer? _moveDebounce;

  @override
  void initState() {
    super.initState();

    // ─────────────────────────────────────────────────────────────────────────
    // ENV 체크 (KAKAO_REST_API_KEY, KAKAO_MAP_API_KEY) — 키 전달 여부 디버깅용
    // ─────────────────────────────────────────────────────────────────────────
    debugPrint('[KakaoMapScreen] initState() 완료');
    debugPrint(
        '[KakaoMapScreen][ENV] kakaoRestApiKey isEmpty=${AppEnv.kakaoRestApiKey.isEmpty} len=${AppEnv.kakaoRestApiKey.length}');
    // 다른 ENV 값들도 필요하면 여기서 같이 찍을 수 있음 (예: kakaoMapApiKey 등)

    _prepareCenterMarkerIcon();
    _loadInitialPosition();
  }

  @override
  void dispose() {
    _moveDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regionName = ref.watch(regionProvider);
    final policyState = ref.watch(policyListNotifierProvider);
    final debugPanelEnabled = ref.watch(debugPanelEnabledProvider);

    if (_currentRequest == null) {
      return Scaffold(
        appBar: const AppAppBar(title: '카카오맵 보기'),
        body: Stack(
          children: [
            const Center(child: CircularProgressIndicator()),
            if (_locationError != null) _buildLocationErrorBanner(),
          ],
        ),
        floatingActionButton: _buildGpsButton(),
      );
    }

    final request = _currentRequest!;
    final centerMarkersAsync = ref.watch(youthCenterMapProvider(request));

    debugPrint('────────────────────────────────────────');
    debugPrint('[KakaoMapScreen] build() 호출');
    debugPrint(' └ regionName: $regionName');
    debugPrint(
        ' └ currentRequest: center=(${request.lat}, ${request.lng}), radius=${request.radiusKm}');
    debugPrint(
        ' └ latestCenter: ${_latestCenter != null ? '(${_latestCenter!.lat}, ${_latestCenter!.lng})' : 'null'}');
    debugPrint(' └ latestZoom: ${_latestZoom ?? -1}');
    debugPrint(' └ 정책 개수: ${policyState.policies.length}');
    debugPrint(' └ centerMarkersAsync = $centerMarkersAsync');
    debugPrint('────────────────────────────────────────');

    final defaultCenter = _centerForRegion(regionName);
    final effectiveRequestCenter =
        _latestCenter ?? KakaoMapLatLng(request.lat, request.lng);

    debugPrint(
        '[KakaoMapScreen] region 기반 defaultCenter=(${defaultCenter.lat}, ${defaultCenter.lng})');
    debugPrint(
        '[KakaoMapScreen] effectiveRequestCenter=(${effectiveRequestCenter.lat}, ${effectiveRequestCenter.lng})');

    return centerMarkersAsync.when(
      // ───────────────────────────────────────────────────────────────────────
      // LOADING 상태
      // ───────────────────────────────────────────────────────────────────────
      loading: () {
        debugPrint('[YCMAP] centerMarkersAsync: LOADING');
        final fallbackCenter = effectiveRequestCenter;
        final policies = _policyMarkers(fallbackCenter, policyState);
        final polylines = _polylinesFromMarkers(policies);
        final locationMarker = _currentLocationMarker;
        final fallbackMarkers = <KakaoMapMarker>[
          if (locationMarker != null) locationMarker,
          ...policies,
        ];

        return Scaffold(
          appBar: const AppAppBar(title: '카카오맵 보기'),
          body: Stack(
            children: [
              KakaoMapWebView(
                center: fallbackCenter,
                markers: fallbackMarkers,
                polylines: polylines,
                enableClustering: true,
                options: const KakaoMapOptions(
                  level: 6,
                  mapType: KakaoMapType.roadmap,
                  showZoomControl: true,
                  showMapTypeControl: true,
                ),
                onMarkerTap: (id) {
                  debugPrint('[KakaoMap] markerTap(LOADING_CENTER) -> $id');
                  if (id.startsWith('CENTER-')) {
                    debugPrint('[KakaoMap] CENTER marker tap routed to handler');
                    return;
                  }
                  context.push(RoutePaths.policyDetail(id));
                },
                onMarkerClicked: _handleCenterMarkerClicked,
                onReady: () {
                  debugPrint('[KakaoMap] WebView Ready! (LOADING state)');
                  _setLoading(false);
                  _showMyPositionOnMap();
                },
                onLoadingChanged: (isLoading) {
                  debugPrint(
                      '[KakaoMap] WebView LoadingChanged(LOADING) → $isLoading');
                  _setLoading(isLoading);
                },
                onError: (code) {
                  debugPrint(
                      '[KakaoMap:ERROR][LOADING] WebView error code=$code');
                  setState(() => _errorCode = code);
                },
                onLog: (event) {
                  debugPrint(
                      '[KakaoMap:LOG][LOADING] ${event.logMessage ?? ''}');
                  setState(() => _lastLog = event.logMessage);
                },
                showDebugPanel: kDebugMode && debugPanelEnabled,
              ),
              if (_loading) const Center(child: CircularProgressIndicator()),
              if (_errorCode != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: _buildErrorBanner(),
                ),
              if (_locationError != null) _buildLocationErrorBanner(),
              if (sortedCenterPoints.isNotEmpty) ...[
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildCenterList(sortedCenterPoints),
                ),
              ],
              Positioned(
                left: 0,
                right: 0,
                top: 16,
                child: _buildOverlay(policyState),
              ),
            ],
          ),
          floatingActionButton: _buildGpsButton(),
        );
      },

      // ───────────────────────────────────────────────────────────────────────
      // ERROR 상태 (FutureProvider 실패)
      // ───────────────────────────────────────────────────────────────────────
      error: (err, stack) {
        debugPrint('[YCMAP] centerMarkersAsync: ERROR = $err');
        if (stack != null) {
          debugPrint('[YCMAP] ERROR stack = $stack');
        }

        final fallbackCenter = effectiveRequestCenter;
        final policies = _policyMarkers(fallbackCenter, policyState);
        final polylines = _polylinesFromMarkers(policies);
        final locationMarker = _currentLocationMarker;
        final fallbackMarkers = <KakaoMapMarker>[
          if (locationMarker != null) locationMarker,
          ...policies,
        ];

        return Scaffold(
          appBar: const AppAppBar(title: '카카오맵 보기'),
          body: Stack(
            children: [
              KakaoMapWebView(
                center: fallbackCenter,
                markers: fallbackMarkers,
                polylines: polylines,
                enableClustering: true,
                options: const KakaoMapOptions(
                  level: 6,
                  mapType: KakaoMapType.roadmap,
                  showZoomControl: true,
                  showMapTypeControl: true,
                ),
                onMarkerTap: (id) {
                  debugPrint('[KakaoMap] markerTap(CENTER_ERROR) -> $id');
                  if (id.startsWith('CENTER-')) {
                    debugPrint('[KakaoMap] CENTER marker tap routed to handler');
                    return;
                  }
                  context.push(RoutePaths.policyDetail(id));
                },
                onMarkerClicked: _handleCenterMarkerClicked,
                onReady: () {
                  debugPrint('[KakaoMap] WebView Ready! (ERROR state)');
                  _setLoading(false);
                  _showMyPositionOnMap();
                },
                onLoadingChanged: (isLoading) {
                  debugPrint(
                      '[KakaoMap] WebView LoadingChanged(ERROR) → $isLoading');
                  _setLoading(isLoading);
                },
                onError: (code) {
                  debugPrint(
                      '[KakaoMap:ERROR][ERROR_STATE] WebView error code=$code');
                  setState(() => _errorCode = code);
                },
                onLog: (event) {
                  debugPrint(
                      '[KakaoMap:LOG][ERROR_STATE] ${event.logMessage ?? ''}');
                  setState(() => _lastLog = event.logMessage);
                },
                showDebugPanel: kDebugMode && debugPanelEnabled,
              ),
              if (_loading) const Center(child: CircularProgressIndicator()),
              if (_errorCode != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: _buildErrorBanner(),
                ),
              if (_locationError != null) _buildLocationErrorBanner(),
              Positioned(
                left: 0,
                right: 0,
                top: 16,
                child: _buildOverlay(policyState),
              ),
            ],
          ),
          floatingActionButton: _buildGpsButton(),
        );
      },

      // ───────────────────────────────────────────────────────────────────────
      // DATA 상태 (센터 좌표 로딩 완료)
      // ───────────────────────────────────────────────────────────────────────
      data: (centerPoints) {
        debugPrint(
            '[YCMAP] centerMarkersAsync: DATA, rawCount=${centerPoints.length}');

        final validCenters =
            centerPoints.where((c) => c.lat != null && c.lng != null).toList();

        final currentCenter = _latestCenter ?? defaultCenter;
        debugPrint(
            '[YCMAP] DATA currentCenter=(${currentCenter.lat}, ${currentCenter.lng})');

        final sortedCenters = validCenters
            .map(
              (c) => (
                point: c,
                distance: _distanceFrom(
                  currentCenter.lat,
                  currentCenter.lng,
                  c.lat,
                  c.lng,
                ),
              ),
            )
            .toList()
          ..sort((a, b) => a.distance.compareTo(b.distance));
        final sortedCenterPoints =
            sortedCenters.map((entry) => entry.point).toList();

        final centerMarkerImage = _centerMarkerIconBase64 != null
            ? KakaoMapMarkerImage(
                url: 'data:image/png;base64,$_centerMarkerIconBase64',
                width: 36,
                height: 36,
                offset: const Offset(18, 36),
              )
            : const KakaoMapMarkerImage(
                url:
                    'https://developers.kakao.com/docs/static/images/marker.png',
                width: 26,
                height: 37,
              );

        final centerMarkers = List.generate(sortedCenterPoints.length, (index) {
          final c = sortedCenterPoints[index];
          final markerId = 'CENTER-$index';
          return KakaoMapMarker(
            id: markerId,
            title: c.name,
            position: KakaoMapLatLng(c.lat, c.lng),
            image: centerMarkerImage,
            extra: {
              'name': c.name,
              'fullAddress': c.fullAddress,
              'phone': c.phone,
              'url': c.url,
              'regionLabel': c.regionLabel,
            },
          );
        });

        debugPrint(
            '[YCMAP] centerPoints=${centerPoints.length} validCenters=${validCenters.length}');
        debugPrint(
            '[YCMAP] centerMarkers=${centerMarkers.length} (지도에 찍을 센터 마커 수)');

        final policyMarkers = _policyMarkers(currentCenter, policyState);
        final locationMarker = _currentLocationMarker;
        final mergedMarkers = <KakaoMapMarker>[
          if (locationMarker != null) locationMarker,
          ...centerMarkers,
          ...policyMarkers,
        ];

        debugPrint(
            '[YCMAP] policyMarkers=${policyMarkers.length}, mergedMarkers=${mergedMarkers.length}');

        final polylines = centerMarkers.isNotEmpty
            ? <KakaoMapPolyline>[]
            : _polylinesFromMarkers(policyMarkers);

        if (centerMarkers.isNotEmpty) {
          debugPrint('[YCMAP] polyline disabled due to center markers');
        }

        KakaoMapLatLng mapCenter = currentCenter;
        int mapLevel = _latestZoom ?? 6;

        if (_latestCenter == null && validCenters.isNotEmpty) {
          final avgLat = validCenters
                  .map((c) => c.lat)
                  .fold<double>(0, (prev, lat) => prev + lat) /
              validCenters.length;
          final avgLng = validCenters
                  .map((c) => c.lng)
                  .fold<double>(0, (prev, lng) => prev + lng) /
              validCenters.length;

          mapCenter = KakaoMapLatLng(avgLat, avgLng);
          mapLevel = _latestZoom ?? 12;

          debugPrint(
              '[YCMAP] mapInitialCenter(centersBased)=(${mapCenter.lat}, ${mapCenter.lng}) zoom=$mapLevel');
        } else {
          debugPrint(
              '[YCMAP] mapInitialCenter(default/current)=(${mapCenter.lat}, ${mapCenter.lng}) zoom=$mapLevel (default)');
        }

        return Scaffold(
          appBar: const AppAppBar(title: '카카오맵 보기'),
          body: Stack(
            children: [
              KakaoMapWebView(
                center: mapCenter,
                markers: mergedMarkers,
                polylines: polylines,
                enableClustering: true,
                options: KakaoMapOptions(
                  level: mapLevel,
                  mapType: KakaoMapType.roadmap,
                  showZoomControl: true,
                  showMapTypeControl: true,
                ),
                onMapMoved: (center, zoom) {
                  debugPrint(
                      '[YCMAP] onMapMoved center=(${center.lat}, ${center.lng}) zoom=$zoom');
                  _latestCenter = center;
                  _latestZoom = zoom;

                  // 디바운스 로그
                  _moveDebounce?.cancel();
                  debugPrint(
                      '[YCMAP] onMapMoved → debounce ${_debounceMs}ms 후 CenterFetchRequest 갱신 예정');

                  _moveDebounce = Timer(
                    const Duration(milliseconds: _debounceMs),
                    () {
                      final req = CenterFetchRequest(
                        lat: center.lat,
                        lng: center.lng,
                        radiusKm: kCenterRangeKm,
                      );
                      debugPrint(
                          '[YCMAP] debounce 완료 → provider 재요청 CenterFetchRequest(lat=${req.lat}, lng=${req.lng}, radius=${req.radiusKm})');

                      setState(() {
                        _currentRequest = req;
                      });

                      unawaited(_updateSearchCircle(center));

                      ref.refresh(youthCenterMapProvider(req));
                    },
                  );
                },
                onMarkerTap: (id) {
                  if (id.startsWith('CENTER-')) {
                    debugPrint('[KakaoMap] CENTER marker tap routed to handler -> $id');
                    return;
                  }

                  debugPrint('[KakaoMap] POLICY marker tapped -> $id');
                  context.push(RoutePaths.policyDetail(id));
                },
                onMarkerClicked: _handleCenterMarkerClicked,
                onReady: () {
                  debugPrint('[KakaoMap] WebView Ready! 지도 로딩 완료 (DATA)');
                  _setLoading(false);
                  _showMyPositionOnMap();
                },
                onLoadingChanged: (isLoading) {
                  debugPrint(
                      '[KakaoMap] WebView LoadingChanged(DATA) → $isLoading');
                  _setLoading(isLoading);
                },
                onError: (code) {
                  debugPrint('[KakaoMap:ERROR][DATA] SDK Fail code=$code');
                  setState(() => _errorCode = code);
                },
                onLog: (event) {
                  debugPrint('[KakaoMap:LOG][DATA] ${event.logMessage ?? ''}');
                  setState(() => _lastLog = event.logMessage);
                },
                showDebugPanel: kDebugMode && debugPanelEnabled,
              ),
              if (_loading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (_errorCode != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: _buildErrorBanner(),
                ),
              if (_locationError != null) _buildLocationErrorBanner(),
              Positioned(
                left: 0,
                right: 0,
                top: 16,
                child: _buildOverlay(policyState),
              ),
            ],
          ),
          floatingActionButton: _buildGpsButton(),
        );
      },
    );
  }

  void _setLoading(bool value) {
    if (_loading == value) return;
    debugPrint('[KakaoMap] 로딩 상태 변경 → $_loading → $value');
    setState(() {
      _loading = value;
    });
  }

  List<KakaoMapMarker> _policyMarkers(
    KakaoMapLatLng center,
    PolicyListState asyncPolicies,
  ) {
    debugPrint('[KakaoMap] Policy markers disabled (replacement logic removed)');
    return const [];
  }

  List<KakaoMapPolyline> _polylinesFromMarkers(List<KakaoMapMarker> markers) {
    if (markers.length < 2) {
      debugPrint('[KakaoMap] 마커가 1개 이하 → 폴리라인 생성 안함');
      return const [];
    }

    debugPrint('[KakaoMap] 폴리라인 생성 [${markers.length}개 마커 연결]');
    return [
      KakaoMapPolyline(
        id: 'policy-path',
        path: markers.map((m) => m.position).toList(),
        strokeColor: '#3478f6',
        strokeWeight: 5,
        strokeOpacity: 0.8,
      ),
    ];
  }

  double _distanceFrom(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180.0);

  KakaoMapLatLng _centerForRegion(String? regionName) {
    debugPrint('[KakaoMap] 지역 선택됨: $regionName');

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
        return _defaultCenter;
    }
  }

  Widget _buildOverlay(PolicyListState state) {
    if (state.isLoading && state.policies.isEmpty) {
      debugPrint('[KakaoMap] 정책 로딩중 (Overlay)');
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.policies.isEmpty) {
      debugPrint('[KakaoMap] 정책 로딩 실패 (Overlay) → ${state.error}');
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '정책을 불러오지 못했습니다.',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '지도 로딩 중 문제가 발생했습니다.',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '오류 코드: ${_errorCode ?? ''}',
            style: const TextStyle(color: Colors.white70),
          ),
          if (_lastLog != null) ...[
            const SizedBox(height: 6),
            Text(
              '최근 로그: $_lastLog',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCenterList(List<CenterMarkerPoint> centers) {
    if (centers.isEmpty) return const SizedBox.shrink();
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 150,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: centers.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, index) {
            final center = centers[index];
            return SizedBox(
              width: 220,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () => _onCenterCardTap(center, index),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          center.name,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          center.regionLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            center.fullAddress,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (center.phone != null && center.phone!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            '전화: ${center.phone}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.blue),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _loadInitialPosition() async {
    if (_isRequestingLocation) return;
    setState(() {
      _isRequestingLocation = true;
      _locationError = null;
    });

    try {
      final serviceEnabled = await _gpsService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _showLocationPermissionGuide(
          LocationBottomSheetIssue.serviceDisabled,
        );
        throw '위치 서비스가 꺼져 있습니다. 설정에서 활성화해주세요.';
      }

      final permissionResult = await _permissionService.ensurePermission();
      if (permissionResult == LocationPermissionIssue.denied) {
        await _showLocationPermissionGuide(
          LocationBottomSheetIssue.permissionDenied,
        );
        throw '위치 권한이 거부되었습니다.';
      }

      if (permissionResult == LocationPermissionIssue.deniedForever) {
        await _showLocationPermissionGuide(
          LocationBottomSheetIssue.permissionPermanentlyDenied,
        );
        throw '위치 권한이 영구히 거부되었으며, 설정에서 위치 권한을 허용해 주세요.';
      }

      final position = await _gpsService.getCurrentPosition();

      if (!mounted) return;

      final location = KakaoMapLatLng(position.latitude, position.longitude);
      final request = CenterFetchRequest(
        lat: location.lat,
        lng: location.lng,
        radiusKm: kCenterRangeKm,
      );

      setState(() {
        _deviceLocation = location;
        _latestCenter = _deviceLocation;
        _latestZoom = 12;
        _currentRequest = request;
      });

      await _moveMapToLocation(location);
      await _updateSearchCircle(location);
      ref.refresh(youthCenterMapProvider(request));
      debugPrint(
          '[KakaoMapScreen] GPS 위치 읽기 완료 (${position.latitude}, ${position.longitude})');
      await _showMyPositionOnMap();
    } catch (error, stack) {
      final message = error?.toString() ??
          '위치 정보를 가져오는 동안 문제가 발생했습니다.';
      debugPrint('[KakaoMapScreen] GPS 위치 읽기 실패: $message');
      if (stack != null) {
        debugPrint(stack.toString());
      }
      if (mounted) {
        setState(() {
          _locationError = message;
        });
      }
      if (_currentRequest == null) {
        await _applyFallbackCenter();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequestingLocation = false;
        });
      }
    }
  }

  Future<void> _showMyPositionOnMap() async {
    final location = _deviceLocation;
    if (location == null) return;
    try {
      final controller = ref.read(kakaoMapControllerProvider);
      await controller.showMyPosition(location);
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] showMyPosition failed: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
    }
  }

  Future<void> _updateSearchCircle(KakaoMapLatLng center) async {
    if (!mounted) return;
    try {
      final controller = ref.read(kakaoMapControllerProvider);
      await controller.updateCircle(center);
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] updateCircle failed: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
    }
  }

  Future<void> _showLocationPermissionGuide(
    LocationBottomSheetIssue issue,
  ) async {
    if (!mounted) return;
    await showLocationPermissionBottomSheet(
      context,
      issue: issue,
    );
  }

  Future<void> _applyFallbackCenter() async {
    if (!mounted) return;
    final fallback = _defaultCenter;
    final request = CenterFetchRequest(
      lat: fallback.lat,
      lng: fallback.lng,
      radiusKm: kCenterRangeKm,
    );

    setState(() {
      _deviceLocation = null;
      _latestCenter = fallback;
      _latestZoom = 12;
      _currentRequest = request;
      _locationError ??= '기본 위치(대구)를 기준으로 지도를 표시합니다.';
    });

    await _moveMapToLocation(fallback);
    await _updateSearchCircle(fallback);
    ref.refresh(youthCenterMapProvider(request));
  }

  Future<void> _moveMapToLocation(KakaoMapLatLng location) async {
    try {
      final controller = ref.read(kakaoMapControllerProvider);
      await controller.moveMapTo(location);
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] moveMapTo failed: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
    }
  }

  Future<void> _prepareCenterMarkerIcon() async {
    try {
      final data = await rootBundle.load('assets/map/center_marker.png');
      final encoded = base64Encode(data.buffer.asUint8List());
      if (!mounted) return;
      setState(() {
        _centerMarkerIconBase64 = encoded;
      });
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] center marker icon load failed: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
    }
  }

  KakaoMapMarker? get _currentLocationMarker {
    final location = _deviceLocation;
    if (location == null) return null;
    return KakaoMapMarker(
      id: 'CURRENT_LOCATION',
      title: '현재 위치',
      position: location,
      image: const KakaoMapMarkerImage(
        url: 'https://developers.kakao.com/docs/static/images/marker.png',
        width: 24,
        height: 35,
      ),
    );
  }

  Widget _buildLocationErrorBanner() {
    final message = _locationError ?? '위치 정보를 사용할 수 없습니다.';
    return Positioned(
      top: 80,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: _isRequestingLocation ? null : _loadInitialPosition,
              child: const Text(
                '다시 시도',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGpsButton() {
    return FloatingActionButton(
      heroTag: 'kakao_map_gps',
      onPressed: _isRequestingLocation ? null : _loadInitialPosition,
      tooltip: '내 위치로 이동',
      child: const Icon(Icons.my_location),
    );
  }

  Future<void> _onCenterCardTap(
    CenterMarkerPoint center,
    int index,
  ) async {
    final markerId = 'CENTER-$index';
    final position = KakaoMapLatLng(center.lat, center.lng);
    await _highlightCenterMarker(markerId, position);
    _showCenterDetailSheet(
      name: center.name,
      address: center.fullAddress,
      phone: center.phone,
      homepageUrl: center.url,
      regionLabel: center.regionLabel,
    );
  }

  Future<void> _highlightCenterMarker(
    String markerId,
    KakaoMapLatLng position,
  ) async {
    try {
      final controller = ref.read(kakaoMapControllerProvider);
      await controller.highlightMarker(markerId, position);
    } catch (error, stack) {
      debugPrint('[KakaoMapScreen] highlightCenterMarker failed: $error');
      if (stack != null) debugPrint(stack.toString());
    }
  }

  void _showCenterDetailSheet({
    required String name,
    required String address,
    String? phone,
    String? homepageUrl,
    required String regionLabel,
  }) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CenterDetailBottomSheet(
        name: name,
        address: address,
        phone: phone,
        homepageUrl: homepageUrl,
        regionLabel: regionLabel,
      ),
    );
  }

  void _handleCenterMarkerClicked(
    String markerId,
    Map<String, dynamic>? extra,
  ) {
    debugPrint('[KakaoMap] markerClicked event -> $markerId');
    if (extra == null) {
      debugPrint('[KakaoMap] center marker payload missing, ignoring');
      return;
    }

    _showCenterDetailSheet(
      name: extra['name']?.toString() ?? '청년센터',
      address: extra['fullAddress']?.toString() ?? '',
      phone: extra['phone']?.toString(),
      homepageUrl: extra['url']?.toString(),
      regionLabel: extra['regionLabel']?.toString() ?? '',
    );
  }
}
