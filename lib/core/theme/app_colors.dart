import 'package:flutter/material.dart';

/// Shadow Chat — dark, high-contrast, neon-accented palette.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color bgPrimary = Color(0xFF0A0E14);
  static const Color bgSecondary = Color(0xFF11151C);
  static const Color bgSurface = Color(0xFF161B24);
  static const Color bgElevated = Color(0xFF1C222D);

  // Neon accents
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonMagenta = Color(0xFFFF2E9A);
  static const Color neonGreen = Color(0xFF39FF88);

  // Text
  static const Color textPrimary = Color(0xFFE6F1F5);
  static const Color textSecondary = Color(0xFF8B98A5);
  static const Color textDisabled = Color(0xFF4A5560);

  // Status
  static const Color error = Color(0xFFFF4D6D);
  static const Color success = Color(0xFF39FF88);
  static const Color warning = Color(0xFFFFC857);

  // Borders / dividers
  static const Color border = Color(0xFF262E3A);

  // Bubble colors (chat)
  static const Color bubbleSent = Color(0xFF14303A);
  static const Color bubbleReceived = Color(0xFF1C222D);
}
