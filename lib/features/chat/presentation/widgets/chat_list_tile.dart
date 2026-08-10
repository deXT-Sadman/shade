import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/chat_thread_entity.dart';

class ChatListTile extends StatelessWidget {
  final ChatThreadEntity chat;
  final VoidCallback onTap;

  const ChatListTile({super.key, required this.chat, required this.onTap});

  String _initials(String title) {
    final parts = title.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final isToday =
        now.year == time.year && now.month == time.month && now.day == time.day;
    return isToday
        ? DateFormat.jm().format(time)
        : DateFormat.MMMd().format(time);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: chat.isGroup
            ? AppColors.neonMagenta.withValues(alpha: 0.15)
            : AppColors.neonCyan.withValues(alpha: 0.15),
        child: Text(
          _initials(chat.title),
          style: TextStyle(
            color: chat.isGroup ? AppColors.neonMagenta : AppColors.neonCyan,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        chat.title,
        style: const TextStyle(
            color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      ),
      subtitle: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline, size: 13, color: AppColors.textDisabled),
          SizedBox(width: 4),
          Text('Encrypted message',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_formatTime(chat.lastMessageAt),
              style:
                  const TextStyle(color: AppColors.textDisabled, fontSize: 12)),
          if (chat.unreadCount > 0) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.neonCyan,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                chat.unreadCount > 99 ? '99+' : chat.unreadCount.toString(),
                style: const TextStyle(
                  color: AppColors.bgPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
