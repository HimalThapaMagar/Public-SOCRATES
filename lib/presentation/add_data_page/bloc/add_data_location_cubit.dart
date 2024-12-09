import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socrates/presentation/add_data_page/bloc/add_data_location_state.dart';
import 'package:socrates/presentation/add_data_page/service/location_firebase_service.dart';
import 'package:socrates/presentation/add_data_page/service/add_data_location_service.dart';
import 'package:socrates/presentation/add_data_page/service/location_storage_service.dart';
// this is the cubit for the add data location which is used to add the data location to the app.
class AddDataLocationCubit extends Cubit<LocationState> {
  // this is the service which is used to add the data location to the app.
  final AddDataLocationService _addDataLocationService;
  // this is the service which is used to store the data location to the app.
  final StorageService _storageService;
  // this is the service which is used to fetch the data location from the firebase.
  final FirebaseService _firebaseService;
  // this is the constructor of the cubit which takes the add data location service, storage service and firebase service as the parameter and sets the initial state of the cubit to LocationState.
  AddDataLocationCubit({
    required AddDataLocationService addDataLocationService,
    required StorageService storageService,
    required FirebaseService firebaseService,
  })  : _addDataLocationService = addDataLocationService,
        _storageService = storageService,
        _firebaseService = firebaseService,
        super(const LocationState());
  // method to check if the user is inside the geofence or not.
  Future<void> checkLocation() async {
    if (kDebugMode) {
      print("checklocation called");
    }
    //at first the state of the cubit is set to LocationState with status as loading. as the location is being checked.
    emit(state.copyWith(status: LocationStatus.loading));
    // then classic try catch block is used to catch the error if there is any error while checking the location.
    try {
      // then the current location of the user is fetched using the add data location service.
      final position = await _addDataLocationService.getCurrentLocation();
      final geofence = state.geofence;
      // then it checks if the geofence is null or not if the geofence is null then it throws an exception that no geofence data available.
      if (geofence == null) {
        throw Exception('No geofence data available');
      }
      // then it checks if the location of the user is inside the geofence or not using the isLocationInPolygon method of the add data location service.
      final isInside = _addDataLocationService.isLocationInPolygon(position, geofence.area);
      // then the state of the cubit is set to LocationState with status as success and isInside as the result of the isLocationInPolygon method.
      emit(state.copyWith(
        status: LocationStatus.success,
        isInside: isInside,
      ));
    } catch (e) {
      // if there is any error while checking the location then the state of the cubit is set to LocationState with status as error and error message as the error.
      emit(state.copyWith(
        status: LocationStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  // method to load the geofence data from the storage.
  Future<void> loadGeofence() async {
    // at first the state of the cubit is set to LocationState with status as loading. as the geofence data is being loaded.
    emit(state.copyWith(status: LocationStatus.loading));

    try {
      // first it checks if the geofence data is available in the storage or not if the geofence data is available in the storage then it sets the state of the cubit to LocationState with status as success and cachedgeofence as the geofence data.
      final cachedGeofence = _storageService.getGeofence();
      if (cachedGeofence != null) {
        emit(state.copyWith(
          status: LocationStatus.success,
          geofence: cachedGeofence,
        ));
        return;
      }

      // If no cached data, fetch from Firebase
      await refreshGeofence();
    } catch (e) {
      emit(state.copyWith(
        status: LocationStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  // method to refresh the geofence data from the firebase and fetch it.
  Future<void> refreshGeofence() async {
    emit(state.copyWith(status: LocationStatus.loading));

    try {
      // first it fetches the geofence data from the firebase using the firebase service.
      final geofence = await _firebaseService.fetchGeofence();
      await _storageService.saveGeofence(geofence);
      // then it sets the state of the cubit to LocationState with status as success and geofence as the geofence data.
      emit(state.copyWith(
        status: LocationStatus.success,
        geofence: geofence,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LocationStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}