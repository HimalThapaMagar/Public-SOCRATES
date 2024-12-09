import 'package:socrates/domain/entities/auth/user.dart';
// this is a abstract class which is used to define the states of the cubit.
abstract class ProfileInfoState{}
// this is the initial state of the cubit which is used to signify that the cubit is loading the user info.
class ProfileInfoLoading extends ProfileInfoState {}
// this is the state of the cubit which is used to signify that the user info is loaded successfully.
class ProfileInfoLoaded extends ProfileInfoState {
  // this is the user entity which is used to store the user info.
  final UserEntity userEntity;
  ProfileInfoLoaded({required this.userEntity});
}
// this state of the cubit is used to signify that the user info is not loaded successfully.
class ProfileInfoFailure extends ProfileInfoState {}