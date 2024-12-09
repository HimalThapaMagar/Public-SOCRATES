import 'package:get_it/get_it.dart';
import 'package:socrates/data/repository/auth/auth_repository_impl.dart';
import 'package:socrates/data/sources/auth/auth_firebase_service.dart';
import 'package:socrates/domain/repository/auth/auth.dart';
import 'package:socrates/domain/usecases/auth/get_user.dart';
import 'package:socrates/domain/usecases/auth/signin.dart';
import 'package:socrates/domain/usecases/auth/signout.dart';
import 'package:socrates/domain/usecases/auth/signup.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl(),
  );

  // sl.registerSingleton<AuthRepository>(
  //   AuthRepositoryImpl(),
  // );
  sl.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(sl<AuthFirebaseService>()));

  sl.registerSingleton<SignupUseCase>(
    SignupUseCase(),
  );

  sl.registerSingleton<SigninUseCase>(
    SigninUseCase(),
  );
  sl.registerSingleton<SignOutUseCase>(SignOutUseCase(sl<AuthRepository>()));
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
}
