import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> sendOtp(String phone);

  Future<Either<Failure, UserEntity>> verifyPin({
    required String phone,
    required String pin,
  });

  Future<Either<Failure, UserEntity>> loginWithGmail(String idToken);
}
