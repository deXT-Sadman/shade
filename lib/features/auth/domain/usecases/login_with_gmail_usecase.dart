import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithGmailUseCase
    implements UseCase<UserEntity, LoginWithGmailParams> {
  final AuthRepository repository;
  LoginWithGmailUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginWithGmailParams params) {
    return repository.loginWithGmail(params.idToken);
  }
}

class LoginWithGmailParams {
  final String idToken;
  LoginWithGmailParams(this.idToken);
}
