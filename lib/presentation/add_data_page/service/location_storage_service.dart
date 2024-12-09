import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:socrates/presentation/add_data_page/models/geofence_model.dart';

// this is the simple storage service which is used to store the geofence data to the shared preferences.
class StorageService {
  // this is the key which is used to store the geofence data to the shared preferences.
  static const String _geofenceKey = 'geofence_data';
  // this is the instance of the shared preferences which is used to store the data to the shared preferences.
  final SharedPreferences _prefs;
  // constructor of the storage service which takes the shared preferences as the parameter and sets the shared preferences to the instance of the shared preferences.
  StorageService(this._prefs);
  // method to save the geofence data to the shared preferences.
  Future<void> saveGeofence(Geofence geofence) async {
    await _prefs.setString(_geofenceKey, jsonEncode(geofence.toJson()));
  }

  // method to get the geofence data from the shared preferences.
  Geofence? getGeofence() {
    final String? jsonStr = _prefs.getString(_geofenceKey);
    if (jsonStr == null) return null;
    return Geofence.fromJson(jsonDecode(jsonStr));
  }

  // method to clear the geofence data from the shared preferences.
  Future<void> clearGeofence() async {
    await _prefs.remove(_geofenceKey);
  }
}
