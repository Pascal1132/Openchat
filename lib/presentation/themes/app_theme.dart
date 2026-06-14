import 'package:flutter/material.dart';

import 'colors.dart';

/// Custom OpenChat theme.
///
/// Avoids Material visual components by exposing a raw palette and minimal
/// ThemeData overrides. Build widgets against AppColors directly for a
/// consistent dark/fun look.
abstract final class AppTheme {
  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primaryMuted,
        selectionHandleColor: AppColors.primary,
      ),
      fontFamily: 'Inter',
    );
  }
}
