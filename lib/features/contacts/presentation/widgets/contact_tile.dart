import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/contact_entity.dart';

class ContactTile extends StatelessWidget {
  final ContactEntity contact;
  final VoidCallback onTap;

  const ContactTile({super.key, required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final initial =
        contact.username.isNotEmpty ? contact.username[0].toUpperCase() : '?';
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.neonCyan.withValues(alpha: 0.15),
        child: Text(initial,
            style: const TextStyle(
                color: AppColors.neonCyan, fontWeight: FontWeight.bold)),
      ),
      title: Text(contact.username,
          style: const TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      subtitle: Text(contact.phone,
          style: const TextStyle(color: AppColors.textSecondary)),
      trailing: const Icon(Icons.chat_bubble_outline,
          color: AppColors.neonCyan, size: 20),
    );
  }
}
