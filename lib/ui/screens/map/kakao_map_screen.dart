import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/constants/env.dart';
import '../../widgets/app_appbar.dart';

class KakaoMapScreen extends StatefulWidget {
  const KakaoMapScreen({super.key});

  @override
  State<KakaoMapScreen> createState() => _KakaoMapScreenState();
}

class _KakaoMapScreenState extends State<KakaoMapScreen> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_mapHtml());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: '카카오맵 보기'),
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller!),
    );
  }

  String _mapHtml() {
    final key = Env.kakaoMapApiKey;
    if (key.isEmpty) {
      return '''<html><body><p style="padding:16px;font-size:16px;">카카오맵 API 키가 설정되지 않았습니다. KAKAO_MAP_API_KEY 환경 변수를 추가해주세요.</p></body></html>''';
    }
    final html = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
  <style>html, body, #map {width:100%; height:100%; margin:0; padding:0;}</style>
  <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=$key"></script>
</head>
<body>
<div id="map"></div>
<script>
  var container = document.getElementById('map');
  var options = {
    center: new kakao.maps.LatLng(35.8714, 128.6014),
    level: 7
  };
  var map = new kakao.maps.Map(container, options);
  var markerPositions = [
    new kakao.maps.LatLng(36.0, 128.4),
    new kakao.maps.LatLng(35.9, 128.6),
    new kakao.maps.LatLng(36.1, 128.7)
  ];
  markerPositions.forEach(function(pos, idx) {
    var marker = new kakao.maps.Marker({position: pos});
    marker.setMap(map);
  });
</script>
</body>
</html>
''';
    return html;
  }
}
