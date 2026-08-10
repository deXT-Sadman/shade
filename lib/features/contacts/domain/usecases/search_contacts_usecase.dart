import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/contact_entity.dart';
import '../repositories/contacts_repository.dart';

class SearchContactsUseCase
    implements UseCase<List<ContactEntity>, SearchContactsParams> {
  final ContactsRepository repository;
  SearchContactsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ContactEntity>>> call(
      SearchContactsParams params) {
    return repository.searchContacts(params.query);
  }
}

class SearchContactsParams {
  final String query;
  SearchContactsParams(this.query);
}
