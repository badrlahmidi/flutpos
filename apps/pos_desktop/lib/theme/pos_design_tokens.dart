import 'package:flutter/material.dart';

/// Tokens visuels alignés sur la maquette Ritaj POS (`docs/ui-inspiration/`).
abstract final class PosDesignTokens {
  PosDesignTokens._();

  static const shellBackground = Color(0xFFF4F6F9);
  static const cardBackground = Color(0xFFFFFFFF);
  static const primaryBlue = Color(0xFF2563EB);
  static const primaryBlueDark = Color(0xFF1E40AF);
  static const payOrange = Color(0xFFF97316);
  static const payOrangeDark = Color(0xFFEA580C);
  static const stockGreen = Color(0xFF16A34A);
  static const stockGreenBg = Color(0xFFDCFCE7);
  static const offlineRed = Color(0xFFEF4444);
  static const textMuted = Color(0xFF64748B);
  static const borderLight = Color(0xFFE2E8F0);

  static const radiusMd = 12.0;
  static const radiusLg = 16.0;

  static List<Color> get categoryAccentColors => const [
        Color(0xFF22C55E),
        Color(0xFFF97316),
        Color(0xFF3B82F6),
        Color(0xFFEC4899),
        Color(0xFFEAB308),
        Color(0xFF8B5CF6),
      ];

  static Color categoryAccent(int index) =>
      categoryAccentColors[index % categoryAccentColors.length];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}
