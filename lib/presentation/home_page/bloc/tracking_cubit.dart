import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socrates/presentation/home_page/services/location_service.dart';
// this is the enum which is used to define the status of the tracking like if the tracking is initial, tracking or stopped.
enum TrackingStatus { initial, tracking, stopped }
// this represents the state of the tracking cubit which is used to track the location of the user.
class TrackingState {
  // this is the status of the tracking which is used to show the status of the tracking to the user.
  final TrackingStatus status;
  // this is the message which is used to show the message to the user if there is any error or message to show to the user.
  final String message;
  // this is the constructor of the tracking state which takes the status and message as the parameter and sets the status and message of the tracking state.
  TrackingState({
    required this.status,
    this.message = '',
  });
}
// this is the cubit for the tracking which is used to track the location of the user.
class TrackingCubit extends Cubit<TrackingState> {
  // this uses the location service to track the location of the user.
  final LocationService _locationService;
  // this is the constructor of the tracking cubit which takes the location service as the parameter and sets the initial state of the cubit to TrackingState with status as initial.
  TrackingCubit(this._locationService)
      : super(TrackingState(status: TrackingStatus.initial));
  // this is the method which is used to initialize the tracking of the user and set the state of the cubit to TrackingState with status as tracking if the tracking is started successfully and to TrackingState with status as stopped if the tracking is stopped successfully.
  Future<void> initialize() async {
    await _locationService.initialize();
    emit(TrackingState(
      status: _locationService.isTracking
          ? TrackingStatus.tracking
          : TrackingStatus.stopped,
    ));
  }
  // this is the method which is used to toggle the tracking of the user and set the state of the cubit to TrackingState with status as tracking if the tracking is started successfully and to TrackingState with status as stopped if the tracking is stopped successfully.
  Future<void> toggleTracking() async {
    // here classic try catch block is used to catch the error if there is any error while starting or stopping the tracking.
    // first it checks if the tracking is started or not if the tracking is started then it stops the tracking and sets the state of the cubit to TrackingState with status as stopped and message as tracking stopped.
    try {
      if (_locationService.isTracking) {
        await _locationService.stopTracking();
        emit(TrackingState(
          status: TrackingStatus.stopped,
          message: 'Tracking stopped',
        ));
      } else { // and if the tracking is not started then it starts the tracking and sets the state of the cubit to TrackingState with status as tracking and message as tracking started
        await _locationService.startTracking();
        emit(TrackingState(
          status: TrackingStatus.tracking,
          message: 'Tracking started',
        ));
      }
    } catch (e) { // if there is any error while starting or stopping the tracking then the state of the cubit is set to TrackingState with status as initial and message as error.
      emit(TrackingState(
        status: state.status,
        message: 'Error: ${e.toString()}',
      ));
    }
  }
}