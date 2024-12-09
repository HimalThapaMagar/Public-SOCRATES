import 'package:dartz/dartz.dart';
import 'package:socrates/data/models/auth/create_user_req.dart';
import 'package:socrates/domain/repository/auth/auth.dart';
import 'package:socrates/service_locator.dart';

// abstract class AuthRepository {
//   // ignore: non_constant_identifier_names
//   Future<Either> SignupUseCase(CreateUserReq createUserReq);
  
  
// }

class SignupUseCase {
  Future<Either> call(CreateUserReq createUserReq, {required CreateUserReq params}) async {
    return await sl<AuthRepository>().signup(createUserReq);
  }
}