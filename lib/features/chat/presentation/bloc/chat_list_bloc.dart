import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/chat_thread_entity.dart';
import '../../domain/usecases/get_user_chats_usecase.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetUserChatsUseCase getUserChatsUseCase;

  ChatListBloc({required this.getUserChatsUseCase}) : super(ChatListLoading()) {
    on<ChatListRequested>(_onRequested);
    on<ChatListSearchChanged>(_onSearchChanged);
  }

  Future<void> _onRequested(
    ChatListRequested event,
    Emitter<ChatListState> emit,
  ) async {
    emit(ChatListLoading());
    final result = await getUserChatsUseCase(const NoParams());
    result.fold(
      (failure) => emit(ChatListError(failure.message)),
      (chats) {
        final sorted = List<ChatThreadEntity>.from(chats)
          ..sort((a, b) {
            final aTime =
                a.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bTime =
                b.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });
        emit(ChatListLoaded(allChats: sorted, filteredChats: sorted));
      },
    );
  }

  void _onSearchChanged(
    ChatListSearchChanged event,
    Emitter<ChatListState> emit,
  ) {
    final current = state;
    if (current is! ChatListLoaded) return;
    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? current.allChats
        : current.allChats
            .where((c) => c.title.toLowerCase().contains(query))
            .toList();
    emit(ChatListLoaded(
        allChats: current.allChats,
        filteredChats: filtered,
        query: event.query));
  }
}
