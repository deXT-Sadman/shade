import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyPinUseCase implements UseCase<UserEntity, VerifyPinParams> {
  final AuthRepository repository;
  VerifyPinUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(VerifyPinParams params) {
    return repository.verifyPin(phone: params.phone, pin: params.pin);
  }
}

class VerifyPinParams {
  final String phone;
  final String pin;
  VerifyPinParams({required this.phone, required this.pin});
}
