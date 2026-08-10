import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/chat_thread_entity.dart';
import '../repositories/chat_repository.dart';

class GetUserChatsUseCase implements UseCase<List<ChatThreadEntity>, NoParams> {
  final ChatRepository repository;
  GetUserChatsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatThreadEntity>>> call(NoParams params) {
    return repository.getUserChats();
  }
}
