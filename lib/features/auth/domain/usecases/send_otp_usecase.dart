import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SendOtpUseCase implements UseCase<void, SendOtpParams> {
  final AuthRepository repository;
  SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendOtpParams params) {
    return repository.sendOtp(params.phone);
  }
}

class SendOtpParams {
  final String phone;
  SendOtpParams(this.phone);
}
