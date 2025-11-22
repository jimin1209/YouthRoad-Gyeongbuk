import 'package:flutter/material.dart';

import 'color_palette.dart';
import 'text_theme.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      brightness: Brightness.light,
      background: AppColors.background,
      error: AppColors.error,
    );

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      useMaterial3: true,
      textTheme: buildTextTheme('Pretendard'),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        shadowColor: Colors.black.withOpacity(0.03),
      ),
    );
  }

  static ThemeData dark() {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryDark,
      primary: AppColors.primaryDark,
      secondary: AppColors.secondary,
      brightness: Brightness.dark,
      error: AppColors.error,
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      textTheme: buildTextTheme('Pretendard'),
      cardTheme: CardTheme(
        color: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        shadowColor: Colors.black.withOpacity(0.08),
      ),
    );
  }
}
