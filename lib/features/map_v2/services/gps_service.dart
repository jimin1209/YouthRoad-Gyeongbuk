import 'package:geolocator/geolocator.dart';

class GpsService {
  const GpsService();

  Future<bool> isLocationServiceEnabled() => Geolocator.isLocationServiceEnabled();

  Future<Position> getCurrentPosition() => Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
}
