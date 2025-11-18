import 'package:flutter/material.dart';

import '../../../core/location/location_service.dart';

class RegionSelectPage extends StatefulWidget {
  const RegionSelectPage({super.key});

  @override
  State<RegionSelectPage> createState() => _RegionSelectPageState();
}

class _RegionSelectPageState extends State<RegionSelectPage> {
  final LocationService _locationService = LocationService();
  bool _loading = false;
  String? _regionCode;
  String? _regionName;
  String? _error;

  Future<void> _useCurrentLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _locationService.getCurrentLocation();
      setState(() {
        _regionCode = result.regionCode;
        _regionName = result.placemark.administrativeArea ?? '-';
      });
    } on Exception catch (error) {
      setState(() {
        _error = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('지역 선택')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '현재 위치로 검색',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'GPS 권한을 허용하면 현재 행정구역을 YouthRoad 지역 코드로 변환해 필터에 적용합니다.',
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.my_location),
              onPressed: _loading ? null : _useCurrentLocation,
              label: Text(_loading ? '위치 확인 중...' : '현재 위치로 검색'),
            ),
            const SizedBox(height: 16),
            if (_regionCode != null)
              Card(
                child: ListTile(
                  title: Text('YouthRoad 코드: $_regionCode'),
                  subtitle: Text('행정구역: ${_regionName ?? '-'}'),
                ),
              ),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            const Spacer(),
            const Text(
              'Unity 지도에서 지역을 선택하면 동일한 YouthRoad 코드가 적용됩니다.',
            ),
          ],
        ),
      ),
    );
  }
}
