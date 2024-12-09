import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socrates/domain/usecases/auth/get_user.dart';
import 'package:socrates/domain/usecases/auth/signout.dart';
import 'package:socrates/presentation/home_page/bloc/profile_state.dart';
import 'package:socrates/service_locator.dart';

// this is the cubit for the profile info which is used to get the user info and logout the user from the app. this is the very basic cubit which is used to get the user info and logout the user from the app.
class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  final SignOutUseCase _signOutUseCase;
// this is the constructor of the cubit which takes the signout usecase as the parameter and sets the initial state of the cubit to ProfileInfoLoading to signify that the cubit is loading the user info.
  ProfileInfoCubit(this._signOutUseCase) : super(ProfileInfoLoading());
  // this is the method which is used to get the user info from the app and set the state of the cubit to ProfileInfoLoaded if the user info is loaded successfully and to ProfileInfoFailure if the user info is not loaded successfully.
  Future<void> getUser() async {
    var user = await sl<GetUserUseCase>().call();
    // this is the check to see if the cubit is closed or not if the cubit is closed then the state of the cubit is not set to ProfileInfoLoaded or ProfileInfoFailure.
    if (!isClosed) {
      // this is the fold method which is used to check if the user is loaded successfully or not if the user is loaded successfully then the state of the cubit is set to ProfileInfoLoaded and if the user is not loaded successfully then the state of the cubit is set to ProfileInfoFailure.
      user.fold((l) {
        emit(ProfileInfoFailure());
      }, (userEntity) {
        emit(ProfileInfoLoaded(userEntity: userEntity));
      });
    }
  }

  // this is the method which is used to logout the user from the app and set the state of the cubit to ProfileInfoFailure if the user is not logged out successfully.
  Future<void> logout() async {
    try {
      await _signOutUseCase.call(); // Call the signout logic
      // Handle further navigation or state reset after logout if needed
    } catch (e) {
      if (kDebugMode) {
        print("Errors in logging out: $e");
      }
    }
  }
}
