import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// this class represents the needed data for the geofence.
class Geofence {
  // unique identifier of the geofence
  final String id;
  // list of the polygon area points of the geofence
  final List<LatLng> area;
  // name of the geofence
  final String name;
  // constructor of the geofence which takes the id, area and name as the parameter and sets the id, area and name of the geofence.
  Geofence({
    required this.id,
    required this.area,
    required this.name,
  });
  
  // factory method to convert the firestore document to the geofence object this is a special type of contructor which gives more flexibility like returning the same instance of the object if the object is already created. which is not possible with the normal constructor.
  // Updated to handle Firestore document
  factory Geofence.fromFirestore(DocumentSnapshot doc) {
    // gets the data from  firebase document
    final data = doc.data() as Map<String, dynamic>;
    // gets the area from the data if the area is null then it sets the area to an empty list.
    final List<dynamic> points = data['area'] ?? [];
    // returns the geofence object with the id as the document id and name as the name from the data and area as the list of points.
    return Geofence(
      id: doc.id, // Use document ID directly
      name: data['name'] ?? '',
      area: points.map((point) {
        // Handle GeoPoint type from Firestore
        if (point is GeoPoint) {
          return LatLng(point.latitude, point.longitude);
        }
        // Fallback for other formats if needed
        return LatLng(0, 0); // this is the deafult value if the point is not a GeoPoint
      }).toList(),
    );
  }

  // Keep this for SharedPreferences storage
  factory Geofence.fromJson(Map<String, dynamic> json) {
    List<dynamic> points = json['area'];
    return Geofence(
      id: json['id'],
      name: json['name'],
      area: points
          .map((point) => LatLng(point['lat'] as double, point['lng'] as double))
          .toList(),
    );
  }
  // method to convert the geofence object to the json data for the local cache in the shared preferences.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area': area
          .map((point) => {'lat': point.latitude, 'lng': point.longitude})
          .toList(),
    };
  }

  // Add method to convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'area': area
          .map((point) => GeoPoint(point.latitude, point.longitude))
          .toList(),
    };
  }
}
