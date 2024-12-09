import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:socrates/presentation/add_data_page/models/geofence_model.dart';

class FirebaseService {
  // this is the instance of the firestore which is used to get the data from the firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // this is the instance of the firebase auth which is used to get the current user.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // this is the method which is used to fetch the geofence data from the firestore.
  Future<Geofence> fetchGeofence() async {
    try {
      // Get the current user
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      // Fetch the user document
      final userDoc = await _firestore.collection('Enumerators').doc(user.uid).get();

      // Get the reference to the assigned geofence from the array
      final assignedGeofences = userDoc.data()?['assignedGeofences'] as List?;

      if (assignedGeofences == null || assignedGeofences.isEmpty) {
        throw Exception('No geofences assigned to this user');
      }

      // Get the first geofence reference from the array
      final geofenceRef = assignedGeofences.first as DocumentReference?;
      if (kDebugMode) {
        print('geofenceRef: $geofenceRef');
      }

      if (geofenceRef == null) {
        throw Exception('Invalid geofence reference');
      }

      // Fetch the geofence document
      final geofenceDoc = await geofenceRef.get();

      if (!geofenceDoc.exists) {
        throw Exception('Assigned geofence document not found');
      }

      // Create Geofence object
      return Geofence.fromFirestore(geofenceDoc);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching geofence: $e');
      }
      throw Exception('Failed to fetch geofence: $e');
    }
  }
}
