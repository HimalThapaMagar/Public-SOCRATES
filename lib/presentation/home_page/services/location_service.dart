import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

// this is the service for location which is used to track and upload the location of the user.
class LocationService {
  // this is the key to store the tracking status in the shared preferences, so that it can know if the tracking is enabled or not when the user restarts the app.
  // ignore: constant_identifier_names
  static const String TRACKING_STATUS_KEY = 'tracking_status';
  // this is the instance of the geolocator which is used to get the location of the user.
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  // this is the instance of the firestore which is used to upload the location of the user.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // this is the instance of the shared preferences which is used to store the tracking status of the user.
  final SharedPreferences _prefs;
  // this is the last position of the user which is used to store the last position of the user.
  Position? _lastPosition;
  bool _isTracking = false;
  // this is the instance of the position subscription which is used to get the position of the user.
  StreamSubscription<Position>? _positionSubscription;
  Timer? _periodicTimer;
  // this is the constructor of the location service which takes the shared preferences as the parameter and sets the shared preferences of the location service.
  LocationService(this._prefs);

  bool get isTracking => _isTracking;
  // this is the method which is used to initialize the location service and check if the tracking was previously enabled or not.
  Future<void> initialize() async {
    // Check if tracking was previously enabled
    _isTracking = _prefs.getBool(TRACKING_STATUS_KEY) ?? false;
    // if the tracking is enabled then it checks the location permissions and services on restart
    if (_isTracking) {
      // Verify location permissions and services on restart
      final serviceEnabled = await _geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _isTracking = false;
        await _prefs.setBool(TRACKING_STATUS_KEY, false);
        throw Exception('Location services are disabled');
      }
      // Check location permissions for the app and request if needed.
      final permission = await _geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _isTracking = false;
        await _prefs.setBool(TRACKING_STATUS_KEY, false);
        throw Exception('Location permissions are required');
      }

      // Ensure clean state before restarting
      await _positionSubscription?.cancel();
      _periodicTimer?.cancel();

      // Start fresh tracking session
      await _startTrackingSession();
    }
  }

  // this is the method which is used to start the tracking of the user and set the state of the cubit to TrackingState with status as tracking if the tracking is started successfully.
  Future<void> _startTrackingSession() async {
    if (kDebugMode) {
      print('Starting new tracking session...');
    }

    // Start immediate location updates
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter:
            10, // minimum distance between location updates in meters
      ),
    ).listen(
      (Position position) {
        if (kDebugMode) {
          print(
              'New position received: ${position.latitude}, ${position.longitude}');
        } // Debug log
        _handlePositionUpdate(position);
      },
      onError: (error) {
        if (kDebugMode) {
          print('Error in position stream: $error');
        } // Debug log
        _restartTrackingOnError();
      },
      cancelOnError: false,
    );

    // Get and upload initial position
    try {
      final position = await _geolocator.getCurrentPosition();
      await _uploadLocation(position);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting initial position: $e');
      } // Debug log
    }

    // Start periodic updates
    _periodicTimer = Timer.periodic(
      const Duration(minutes: 15),
      (timer) async {
        if (kDebugMode) {
          print('Periodic update timer fired');
        } // Debug log
        await _getCurrentLocationAndUpload();
      },
    );
  }

  // this is the method which is used to start the tracking of the user
  Future<void> startTracking() async {
    // Check if already tracking
    if (_isTracking) return;

    final permission = await _geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final status = await _geolocator.requestPermission();
      if (status == LocationPermission.denied ||
          status == LocationPermission.deniedForever) {
        throw Exception('Location permissions are required');
      }
    }
    // Start tracking if not already started.
    _isTracking = true;
    await _prefs.setBool(TRACKING_STATUS_KEY, true);
    await _startTrackingSession();
  }

  // this is the method which is used to restart the tracking if there is any error while tracking.
  Future<void> _restartTrackingOnError() async {
    if (kDebugMode) {
      print('Attempting to restart tracking after error');
    } // Debug log

    // Cancel existing subscriptions
    await _positionSubscription?.cancel();
    _periodicTimer?.cancel();

    // Wait briefly before attempting restart
    await Future.delayed(const Duration(seconds: 2));

    if (_isTracking) {
      await _startTrackingSession();
    }
  }

  // this is the method which is used to handle the position update of the user.
  Future<void> _handlePositionUpdate(Position position) async {
    if (!_isTracking) return;

    if (_lastPosition != null) {
      final distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );

      if (distance >= 10) {
        await _uploadLocation(position);
        _lastPosition = position;
      }
    } else {
      await _uploadLocation(position);
      _lastPosition = position;
    }
  }

  // this is the method which is used to get the current location of the user and upload it to the firestore.
  Future<void> _getCurrentLocationAndUpload() async {
    // if already tracking uploadlocation doesnot need to be called
    if (!_isTracking) return;
    // but if not tracking then get the current location and upload it to the firestore
    try {
      final position = await _geolocator.getCurrentPosition();
      await _uploadLocation(position);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current location: $e');
      }
    }
  }

  // this is the method which is used to upload the location of the user to the firestore.
  Future<void> _uploadLocation(Position position) async {
      // this is the instance of the user which is used to get the current user.
  final user = FirebaseAuth.instance.currentUser?.uid;
    // this is the reference of the enumerator which is used to get the enumerator id. and point to the enumerator id, reference is used because it will be more error proof.
    DocumentReference enumeratorRef =
        _firestore.collection('Enumerators').doc(user);
        if (kDebugMode) {
          print("Enumerator ID: ${enumeratorRef.id}");
        }
    // this uses classic try catch block to catch the error if there is any error while uploading the location.
    try {
      // this sets the locations in the firestore with the latitude, longitude, timestamp, enumerator id, heading, accuracy and speed.
      await _firestore.collection('locations').doc(user).set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
        'enumeratorID': enumeratorRef,
        'heading': position.heading,
        'accuracy': position.accuracy,
        'speed': position.speed,
      });
      if (kDebugMode) {
        print("Location uploaded: ${position.latitude}, ${position.longitude}");
        print("Document ID: $user");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading location: $e');
      }
    }
  }

  // this is the method which is used to stop the tracking of the user.
  Future<void> stopTracking() async {
    _isTracking = false; // Stop tracking
    await _prefs.setBool(TRACKING_STATUS_KEY,
        false); // this sets the tracking status to false in the shared preferences. so that it will not auto start tracking the next time the app is opened.
    // this cancels the position subscription and the periodic timer.
    await _positionSubscription?.cancel();
    _positionSubscription = null;

    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  // at last this is the dispose method which is used to dispose the position subscription and the periodic timer. and cleans up the resources.
  Future<void> dispose() async {
    await _positionSubscription?.cancel();
    _periodicTimer?.cancel();
  }
}
