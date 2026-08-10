import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_thread_entity.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();
  @override
  List<Object?> get props => [];
}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ChatThreadEntity> allChats;
  final List<ChatThreadEntity> filteredChats;
  final String query;

  const ChatListLoaded({
    required this.allChats,
    required this.filteredChats,
    this.query = '',
  });

  @override
  List<Object?> get props => [allChats, filteredChats, query];
}

class ChatListError extends ChatListState {
  final String message;
  const ChatListError(this.message);
  @override
  List<Object?> get props => [message];
}
