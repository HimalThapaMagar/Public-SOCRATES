
import 'package:dartz/dartz.dart';
import 'package:socrates/data/models/auth/create_user_req.dart';
import 'package:socrates/data/models/auth/sign_in_user_req.dart';
import 'package:socrates/data/sources/auth/auth_firebase_service.dart';
import 'package:socrates/domain/repository/auth/auth.dart';
import 'package:socrates/service_locator.dart';

class AuthRepositoryImpl  extends AuthRepository{
  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    return await sl<AuthFirebaseService>().signin(signinUserReq);
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    return await sl<AuthFirebaseService>().signup(createUserReq);
  }
    @override
  Future<Either> getUser() async {
    return await sl<AuthFirebaseService>().getUser();
  }

  final AuthFirebaseService _firebaseService; // Use your service

  AuthRepositoryImpl(this._firebaseService);
  @override
    Future<void> signOut() async {
    await _firebaseService.signOut(); // Use the signout method from your service
  }
}