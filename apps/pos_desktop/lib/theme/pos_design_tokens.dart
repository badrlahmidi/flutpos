import 'package:flutter/material.dart';
import '../navigation/app_router.dart';
import 'app_colors.dart';

/// Tokens visuels alignés sur le design system.
/// S'adaptent dynamiquement à la luminosité du thème actif.
abstract final class PosDesignTokens {
  PosDesignTokens._();

  static bool get isDark {
    final context = appRouter.routerDelegate.navigatorKey.currentContext;
    if (context == null) return true;
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color get shellBackground =>
      isDark ? AppColors.scaffoldDark : const Color(0xFFF4F5F7);

  static Color get cardBackground =>
      isDark ? AppColors.surfaceDark : Colors.white;

  static Color get primaryBlue =>
      isDark ? AppColors.accentBlue : AppColors.primary;

  static Color get primaryBlueDark =>
      isDark ? const Color(0xFF4A6FD4) : const Color(0xFF1A237E);

  static Color get payOrange =>
      isDark ? AppColors.accentOrange : const Color(0xFFEA580C);

  static Color get payOrangeDark =>
      isDark ? const Color(0xFFEA580C) : const Color(0xFFC2410C);

  static Color get stockGreen =>
      isDark ? AppColors.accentGreen : const Color(0xFF16A34A);

  static Color get stockGreenBg =>
      isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7);

  static Color get offlineRed =>
      isDark ? AppColors.accentRed : const Color(0xFFDC2626);

  static Color get textMuted =>
      isDark ? AppColors.textMuted : const Color(0xFF64748B);

  static Color get borderLight =>
      isDark ? AppColors.borderSubtle : const Color(0xFFE2E8F0);

  static const radiusMd = 12.0;
  static const radiusLg = 16.0;

  static List<Color> get categoryAccentColors => isDark
      ? const [
          AppColors.accentGreen,
          AppColors.accentOrange,
          AppColors.accentBlue,
          Color(0xFFEC4899),
          Color(0xFFEAB308),
          AppColors.accentPurple,
        ]
      : const [
          Color(0xFF0F766E),
          Color(0xFFC2410C),
          Color(0xFF1D4ED8),
          Color(0xFFBE185D),
          Color(0xFFB45309),
          Color(0xFF6D28D9),
        ];

  static Color categoryAccent(int index) =>
      categoryAccentColors[index % categoryAccentColors.length];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}
