import '../../domain/entities/chat_thread_entity.dart';

class ChatThreadModel extends ChatThreadEntity {
  const ChatThreadModel({
    required super.id,
    required super.title,
    required super.isGroup,
    super.avatarUrl,
    required super.participantIds,
    super.lastMessageAt,
    super.unreadCount,
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) {
    return ChatThreadModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown',
      isGroup: json['isGroup'] == true,
      avatarUrl: json['avatarUrl']?.toString(),
      participantIds: (json['participantIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'].toString())
          : null,
      unreadCount: json['unreadCount'] is int ? json['unreadCount'] as int : 0,
    );
  }
}
