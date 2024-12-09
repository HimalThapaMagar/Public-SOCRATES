import 'package:dartz/dartz.dart';
import 'package:socrates/core/usecases/usecase.dart';
import 'package:socrates/domain/repository/auth/auth.dart';


import '../../../service_locator.dart';

class GetUserUseCase implements Usecase<Either,dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<AuthRepository>().getUser();
  }

}
