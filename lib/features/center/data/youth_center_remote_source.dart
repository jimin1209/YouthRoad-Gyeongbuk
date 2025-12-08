import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../env/app_env.dart';

class LatLng {
  final double lat;
  final double lng;

  const LatLng(this.lat, this.lng);
}

class YouthCenterGeocodingRemoteSource {
  Future<LatLng?> geocodeAddress(String address) async {
    if (AppEnv.kakaoRestApiKey.isEmpty) {
      return null;
    }

    final url = Uri.parse(
      'https://dapi.kakao.com/v2/local/search/address.json?query=$address',
    );

    final resp = await http.get(url, headers: {
      'Authorization': 'KakaoAK ${AppEnv.kakaoRestApiKey}',
    });

    if (resp.statusCode != 200) return null;

    final jsonData = jsonDecode(resp.body);
    final docs = jsonData['documents'] as List?;
    if (docs == null || docs.isEmpty) return null;

    final y = docs[0]['y']?.toString();
    final x = docs[0]['x']?.toString();
    if (y == null || x == null) return null;

    return LatLng(
      double.parse(y),
      double.parse(x),
    );
  }
}
