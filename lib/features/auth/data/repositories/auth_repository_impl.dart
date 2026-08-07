import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/security/key_manager.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final KeyManager keyManager;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.keyManager,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, void>> sendOtp(String phone) async {
    try {
      await remoteDataSource.sendOtp(phone);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyPin({
    required String phone,
    required String pin,
  }) async {
    try {
      final publicKey = await keyManager.getOrCreatePublicKey();
      final user = await remoteDataSource.verifyPin(
        phone: phone,
        pin: pin,
        publicKey: publicKey,
      );
      // Note: JWT persistence happens via a token field the backend returns;
      // extend UserModel/response parsing to include & store it here once
      // your backend contract is finalized.
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGmail(String idToken) async {
    try {
      final publicKey = await keyManager.getOrCreatePublicKey();
      final user = await remoteDataSource.loginWithGmail(
        idToken: idToken,
        publicKey: publicKey,
      );
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
