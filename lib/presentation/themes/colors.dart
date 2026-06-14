import 'package:flutter/material.dart';

/// OpenChat custom color palette.
///
/// Dark-first, fun but neutral aesthetic inspired by ChatGPT/Claude but with
/// a personality of its own.
abstract final class AppColors {
  static const Color background = Color(0xFF0D0D0F);
  static const Color surface = Color(0xFF141416);
  static const Color surfaceRaised = Color(0xFF1C1C1F);
  static const Color surfaceOverlay = Color(0xFF252529);

  static const Color primary = Color(0xFF8C5CFF);
  static const Color primaryMuted = Color(0xFFB89BFF);
  static const Color accent = Color(0xFF00D9C0);

  static const Color textPrimary = Color(0xFFF3F3F5);
  static const Color textSecondary = Color(0xFFB4B4BE);
  static const Color textTertiary = Color(0xFF71717A);

  static const Color border = Color(0xFF2E2E33);
  static const Color borderLight = Color(0xFF3F3F46);

  static const Color userBubble = Color(0xFF8C5CFF);
  static const Color assistantBubble = Color(0xFF1C1C1F);
  static const Color codeBlock = Color(0xFF0F1115);

  static const Color error = Color(0xFFFF5C5C);
  static const Color success = Color(0xFF00D9C0);
}
