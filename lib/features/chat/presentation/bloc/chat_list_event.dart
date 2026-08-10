import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();
  @override
  List<Object?> get props => [];
}

class ChatListRequested extends ChatListEvent {}

class ChatListSearchChanged extends ChatListEvent {
  final String query;
  const ChatListSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}
