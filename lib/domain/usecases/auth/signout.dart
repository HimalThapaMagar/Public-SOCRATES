import 'package:socrates/domain/repository/auth/auth.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> call() async {
    return _authRepository.signOut();
  }
}
