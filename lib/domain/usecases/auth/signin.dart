import 'package:dartz/dartz.dart';
import 'package:socrates/data/models/auth/sign_in_user_req.dart';
import 'package:socrates/domain/repository/auth/auth.dart';
import 'package:socrates/service_locator.dart';

// abstract class AuthRepository {
//   // ignore: non_constant_identifier_names
//   Future<Either> SignupUseCase(CreateUserReq createUserReq);
  
  
// }

class SigninUseCase {
  Future<Either> call(SigninUserReq signinUserReq, {required SigninUserReq params}) async {
    return await sl<AuthRepository>().signin(signinUserReq);
  }
}

  // class SigninUseCase implements Usecase<Either,SigninUserReq>{

  //   @override
  //   Future<Either> call (SigninUserReq signinUserReq, {SigninUserReq ? params}) async {
  //     return sl<AuthRepository>().signin(params!);
  //   }
  // }