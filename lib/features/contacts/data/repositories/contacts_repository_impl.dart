import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../datasources/contacts_remote_data_source.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsRemoteDataSource remoteDataSource;
  ContactsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ContactEntity>>> searchContacts(
      String query) async {
    try {
      final contacts = await remoteDataSource.searchContacts(query);
      return Right(contacts);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
