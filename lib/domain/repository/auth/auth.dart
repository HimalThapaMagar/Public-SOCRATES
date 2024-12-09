import 'package:dartz/dartz.dart';
import 'package:socrates/data/models/auth/create_user_req.dart';
import 'package:socrates/data/models/auth/sign_in_user_req.dart';

abstract class AuthRepository {

  Future<Either> signup(CreateUserReq createUserReq);

  Future<Either> signin(SigninUserReq signinUserReq);
    Future<Either> getUser();
    Future<void> signOut();
}