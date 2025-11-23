import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Unity 대신 간단히 구글맵을 보여주는 화면.
class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late GoogleMapController _controller;
  final LatLng _center = const LatLng(36.576, 128.505); // 경북 중심 부근
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('center'),
      position: LatLng(36.576, 128.505),
      infoWindow: InfoWindow(title: '경북 청년정책 지도'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Map 보기')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _center, zoom: 9.5),
        markers: _markers,
        onMapCreated: (c) => _controller = c,
      ),
    );
  }
}
