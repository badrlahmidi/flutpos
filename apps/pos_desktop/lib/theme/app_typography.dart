import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typographie Inter — utilisée pour assembler [ThemeData] uniquement.
abstract final class AppTypography {
  static TextTheme textTheme(ColorScheme colorScheme) {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Style monospace pour montants et prix.
  static TextStyle priceStyle(ColorScheme scheme) => GoogleFonts.jetBrainsMono(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      );
}
