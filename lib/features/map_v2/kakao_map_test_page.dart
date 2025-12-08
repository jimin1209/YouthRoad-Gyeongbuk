import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ui/widgets/app_appbar.dart';
import 'kakao_map_html_builder.dart';
import 'kakao_map_webview.dart';

class KakaoMapTestPage extends ConsumerStatefulWidget {
  const KakaoMapTestPage({super.key});

  @override
  ConsumerState<KakaoMapTestPage> createState() => _KakaoMapTestPageState();
}

class _KakaoMapTestPageState extends ConsumerState<KakaoMapTestPage> {
  final List<String> _logs = [];
  String? _lastError;
  bool _isLoading = true;
  int _readyCount = 0;

  static const KakaoMapLatLng _testCenter = KakaoMapLatLng(37.5665, 126.9780);
  static const List<KakaoMapMarker> _testMarkers = [
    KakaoMapMarker(
      id: 'city-hall',
      title: '서울시청',
      position: KakaoMapLatLng(37.5665, 126.9780),
    ),
    KakaoMapMarker(
      id: 'gangnam',
      title: '강남역',
      position: KakaoMapLatLng(37.4979, 127.0276),
    ),
    KakaoMapMarker(
      id: 'hongdae',
      title: '홍대입구',
      position: KakaoMapLatLng(37.5571, 126.9238),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'KakaoMap Test V2'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '네트워크 환경에 관계없이 카카오맵 SDK 로딩을 검증하는 테스트 화면입니다.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  '상태: ${_isLoading ? '로딩 중' : '완료'} / ready 이벤트: $_readyCount회',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (_lastError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '에러 코드: $_lastError',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _readyCount = 0),
                      icon: const Icon(Icons.clear),
                      label: const Text('Ready 카운트 초기화'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _logs.clear()),
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('로그 지우기'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: KakaoMapWebView(
                    center: _testCenter,
                    markers: _testMarkers,
                    options: const KakaoMapOptions(
                      level: 7,
                      mapType: KakaoMapType.roadmap,
                      showZoomControl: true,
                      showMapTypeControl: true,
                    ),
                    enableClustering: true,
                    onReady: _handleReady,
                    onLoadingChanged: (loading) => setState(() => _isLoading = loading),
                    onError: (code) => setState(() => _lastError = code),
                    onLog: (event) => _appendLog(event.logMessage ?? event.message.type),
                    showDebugPanel: true,
                    radiusKm: 20,
                  ),
                ),
                _buildLogPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleReady() {
    setState(() {
      _readyCount += 1;
      _lastError = null;
    });
  }

  void _appendLog(String message) {
    setState(() {
      _logs.add(message);
      if (_logs.length > 50) {
        _logs.removeAt(0);
      }
    });
  }

  Widget _buildLogPanel() {
    return Container(
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.bug_report, color: Colors.white, size: 18),
              SizedBox(width: 6),
              Text(
                'Debug 로그',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _logs.reversed
                    .map(
                      (log) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          log,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
