import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contact_entity.dart';

abstract class ContactsRepository {
  Future<Either<Failure, List<ContactEntity>>> searchContacts(String query);
}
