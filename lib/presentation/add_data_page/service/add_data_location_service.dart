import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:turf/turf.dart' as turf;

class AddDataLocationService {
  // this simple method is used to get the current location of the user.
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
  // this is the main method of the service which is used to check if the location of the user is inside the geofence or not.
  // it takes the position of the user and the area of the geofence as the parameter and returns the boolean if the user is inside the geofence or not.
  bool isLocationInPolygon(Position position, List<LatLng> area) {
    final point = turf.Position(position.longitude, position.latitude);
    final List<turf.Position> positions = area
        .map((latLng) => turf.Position(latLng.longitude, latLng.latitude))
        .toList();

    final turfPolygon = turf.Polygon(
      coordinates: [positions],
    );

    return turf.booleanPointInPolygon(point, turfPolygon);
  }
}