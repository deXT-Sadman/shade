import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_thread_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatThreadEntity>>> getUserChats();
}
