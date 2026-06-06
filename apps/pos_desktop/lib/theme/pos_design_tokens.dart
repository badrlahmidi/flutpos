import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tokens visuels alignés sur le design system Dark Pro.
abstract final class PosDesignTokens {
  PosDesignTokens._();

  static const shellBackground = AppColors.scaffoldDark;
  static const cardBackground = AppColors.surfaceDark;
  static const primaryBlue = AppColors.accentBlue;
  static const primaryBlueDark = Color(0xFF4A6FD4);
  static const payOrange = AppColors.accentOrange;
  static const payOrangeDark = Color(0xFFEA580C);
  static const stockGreen = AppColors.accentGreen;
  static const stockGreenBg = Color(0xFF14532D);
  static const offlineRed = AppColors.accentRed;
  static const textMuted = AppColors.textMuted;
  static const borderLight = AppColors.borderSubtle;

  static const radiusMd = 12.0;
  static const radiusLg = 16.0;

  static List<Color> get categoryAccentColors => const [
        AppColors.accentGreen,
        AppColors.accentOrange,
        AppColors.accentBlue,
        Color(0xFFEC4899),
        Color(0xFFEAB308),
        AppColors.accentPurple,
      ];

  static Color categoryAccent(int index) =>
      categoryAccentColors[index % categoryAccentColors.length];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}
