import 'package:equatable/equatable.dart';

class ChatThreadEntity extends Equatable {
  final String id;
  final String title;
  final bool isGroup;
  final String? avatarUrl;
  final List<String> participantIds;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ChatThreadEntity({
    required this.id,
    required this.title,
    required this.isGroup,
    this.avatarUrl,
    required this.participantIds,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        isGroup,
        avatarUrl,
        participantIds,
        lastMessageAt,
        unreadCount
      ];
}
