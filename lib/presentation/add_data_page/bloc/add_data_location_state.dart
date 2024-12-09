import 'package:equatable/equatable.dart';
import 'package:socrates/presentation/add_data_page/models/geofence_model.dart';
// this enum represents the status of the location like if the location is initial, loading, success or error.
enum LocationStatus { initial, loading, success, error }
// this is the state of the cubit which is used to store the location state of the user.
class LocationState extends Equatable {
  final LocationStatus status;  // this is the current status of the location
  final bool? isInside; // this is the boolean which is used to check if the user is inside the geofence or not.
  final Geofence? geofence; // this is the current geofence data of the user
  final String? errorMessage; // this holds the error message if there is any error while checking the location.
  // this is the constructor of the location state which takes the status, isInside, geofence and errorMessage as the parameter and sets the status, isInside, geofence and errorMessage of the location state.
  const LocationState({
    this.status = LocationStatus.initial,
    this.isInside,
    this.geofence,
    this.errorMessage,
  });
  // this is the copyWith method which is used to copy the current state of the location and set the new values of the status, isInside, geofence and errorMessage.
  LocationState copyWith({
    LocationStatus? status,
    bool? isInside,
    Geofence? geofence,
    String? errorMessage,
  }) {
    return LocationState(
      status: status ?? this.status,
      isInside: isInside ?? this.isInside,
      geofence: geofence ?? this.geofence,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  // this is the props method which is used to compare the current state of the location with the new state of the location.
  // this is required to check if the state of the location is changed or not.
  @override
  List<Object?> get props => [status, isInside, geofence, errorMessage];
}
