import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationResult {
  const LocationResult({
    required this.latitude,
    required this.longitude,
    required this.placemark,
    this.regionCode,
  });

  final double latitude;
  final double longitude;
  final Placemark placemark;
  final String? regionCode;
}

class LocationService {
  LocationService({YouthRoadRegionMapper? regionMapper})
      : _regionMapper = regionMapper ?? const YouthRoadRegionMapper();

  final YouthRoadRegionMapper _regionMapper;

  Future<bool> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<LocationResult> getCurrentLocation() async {
    final allowed = await ensurePermission();
    if (!allowed) {
      throw const LocationServiceDisabledException();
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
      localeIdentifier: 'ko_KR',
    );
    final placemark = placemarks.first;
    final regionCode = _regionMapper.fromPlacemark(placemark);
    return LocationResult(
      latitude: position.latitude,
      longitude: position.longitude,
      placemark: placemark,
      regionCode: regionCode,
    );
  }
}

class YouthRoadRegionMapper {
  const YouthRoadRegionMapper();

  static const Map<String, String> _provinceMap = {
    '서울특별시': '11',
    '부산광역시': '26',
    '대구광역시': '27',
    '인천광역시': '28',
    '광주광역시': '29',
    '대전광역시': '30',
    '울산광역시': '31',
    '세종특별자치시': '36',
    '경기도': '41',
    '강원특별자치도': '42',
    '충청북도': '43',
    '충청남도': '44',
    '전북특별자치도': '45',
    '전라남도': '46',
    '경상북도': '47',
    '경상남도': '48',
    '제주특별자치도': '49',
  };

  String? fromPlacemark(Placemark placemark) {
    final administrativeArea = placemark.administrativeArea?.trim();
    if (administrativeArea == null || administrativeArea.isEmpty) {
      return null;
    }
    return _provinceMap[administrativeArea];
  }
}
