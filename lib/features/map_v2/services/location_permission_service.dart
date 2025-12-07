import 'package:geolocator/geolocator.dart';

enum LocationPermissionIssue {
  granted,
  denied,
  deniedForever,
}

class LocationPermissionService {
  const LocationPermissionService();

  Future<LocationPermissionIssue> ensurePermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionIssue.deniedForever;
    }
    if (permission == LocationPermission.denied) {
      return LocationPermissionIssue.denied;
    }
    return LocationPermissionIssue.granted;
  }
}
