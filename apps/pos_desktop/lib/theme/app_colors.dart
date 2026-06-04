import 'package:flutter/material.dart';

/// Couleurs de marque — utilisées UNIQUEMENT pour construire [ThemeData].
/// Les widgets doivent utiliser [Theme.of(context).colorScheme].
abstract final class AppColors {
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
}
