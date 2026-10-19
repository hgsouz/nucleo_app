import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tema global do aplicativo (cores, tipografia e componentes).
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blue,
        primary: AppColors.blue,
        onPrimary: AppColors.white,
        surface: AppColors.cream,
        onSurface: AppColors.navy,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.navy,
        displayColor: AppColors.navy,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        contentTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

/// Estilos de texto reutilizáveis (títulos, rótulos e apoio).
class AppText {
  AppText._();

  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    height: 1.15,
    fontWeight: FontWeight.w800,
    letterSpacing: -1,
    color: AppColors.navy,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.navy,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 15,
    height: 1.4,
    fontWeight: FontWeight.w700,
    color: AppColors.navy,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.4,
    color: AppColors.blue,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    height: 1.5,
    color: AppColors.textMuted,
  );

  static const TextStyle small = TextStyle(
    fontSize: 11,
    color: AppColors.textMuted,
  );
}
