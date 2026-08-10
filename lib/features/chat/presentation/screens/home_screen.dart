import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';
import '../bloc/chat_list_bloc.dart';
import '../bloc/chat_list_event.dart';
import '../bloc/chat_list_state.dart';
import '../widgets/chat_list_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ChatListBloc>()..add(ChatListRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shade'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.neonCyan),
                onPressed: () =>
                    context.read<ChatListBloc>().add(ChatListRequested()),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Builder(
                builder: (context) => TextField(
                  style: const TextStyle(color: AppColors.textPrimary),
                  onChanged: (value) => context
                      .read<ChatListBloc>()
                      .add(ChatListSearchChanged(value)),
                  decoration: const InputDecoration(
                    hintText: 'Search chats',
                    prefixIcon:
                        Icon(Icons.search, color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ChatListBloc, ChatListState>(
                builder: (context, state) {
                  if (state is ChatListLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.neonCyan));
                  }
                  if (state is ChatListError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wifi_off,
                                color: AppColors.textDisabled, size: 40),
                            const SizedBox(height: 12),
                            Text(state.message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: AppColors.textSecondary)),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => context
                                  .read<ChatListBloc>()
                                  .add(ChatListRequested()),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is ChatListLoaded) {
                    if (state.filteredChats.isEmpty) {
                      return Center(
                        child: Text(
                          state.query.isEmpty
                              ? 'No chats yet'
                              : 'No matches for "${state.query}"',
                          style: const TextStyle(color: AppColors.textDisabled),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: state.filteredChats.length,
                      separatorBuilder: (_, __) => const Divider(
                          height: 1, indent: 76, color: AppColors.border),
                      itemBuilder: (context, index) {
                        final chat = state.filteredChats[index];
                        return ChatListTile(
                          chat: chat,
                          onTap: () {
                            // Day 4: Navigator.push -> ChatScreen(chatId: chat.id)
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
