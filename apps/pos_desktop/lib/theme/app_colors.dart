import 'package:flutter/material.dart';

/// Couleurs de marque — utilisées UNIQUEMENT pour construire [ThemeData].
/// Les widgets doivent utiliser [Theme.of(context).colorScheme].
abstract final class AppColors {
  // ─── LIGHT PALETTE (conservée) ───
  static const Color primary = Color(0xFF3949AB);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFE8EAF6);
  static const Color onPrimaryContainer = Color(0xFF1A237E);

  static const Color secondary = Color(0xFFFFB300);
  static const Color onSecondary = Color(0xFF000000);
  static const Color secondaryContainer = Color(0xFFFFF8E1);
  static const Color onSecondaryContainer = Color(0xFFE65100);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF212121);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color onSurfaceVariant = Color(0xFF616161);

  static const Color background = Color(0xFFFAFAFA);
  static const Color onBackground = Color(0xFF212121);

  static const Color error = Color(0xFFD32F2F);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color onErrorContainer = Color(0xFFB71C1C);

  static const Color outline = Color(0xFFBDBDBD);
  static const Color outlineVariant = Color(0xFFE0E0E0);

  // ─── DARK PALETTE (principale) ───
  static const scaffoldDark = Color(0xFF0F1117);
  static const surfaceDark = Color(0xFF1A1D27);
  static const surfaceElevated = Color(0xFF232733);
  static const surfaceHover = Color(0xFF2A2E3B);

  static const accentBlue = Color(0xFF6C8EFF);
  static const accentGreen = Color(0xFF4ADE80);
  static const accentOrange = Color(0xFFFB923C);
  static const accentRed = Color(0xFFEF4444);
  static const accentPurple = Color(0xFFA78BFA);

  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted = Color(0xFF64748B);

  static const borderSubtle = Color(0xFF2A2E3B);
  static const borderActive = Color(0xFF6C8EFF);

  static ColorScheme get lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        outline: outline,
        outlineVariant: outlineVariant,
      );

  static ColorScheme get darkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: accentBlue,
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFF1E2A4A),
        onPrimaryContainer: accentBlue,
        secondary: accentOrange,
        onSecondary: Color(0xFF000000),
        secondaryContainer: Color(0xFF3D2800),
        onSecondaryContainer: accentOrange,
        surface: surfaceDark,
        onSurface: textPrimary,
        surfaceContainerHighest: surfaceElevated,
        onSurfaceVariant: textSecondary,
        error: accentRed,
        onError: Color(0xFFFFFFFF),
        errorContainer: Color(0xFF3D0000),
        onErrorContainer: accentRed,
        outline: borderSubtle,
        outlineVariant: Color(0xFF1E2230),
        tertiary: accentPurple,
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFF2D1F5E),
        onTertiaryContainer: accentPurple,
      );
}
