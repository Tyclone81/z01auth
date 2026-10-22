import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for the pure monochrome Black & White design system of Z01auth.
class Z01Colors {
  // Pure Black (Dark Theme) Tokens
  static const Color darkBg = Color(0xFF000000);
  static const Color darkCard = Color(0xFF0C0C0C);
  static const Color darkCardElevated = Color(0xFF161616);
  static const Color darkBorder = Color(0xFF262626);
  static const Color darkBorderStrong = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkMuted = Color(0xFF888888);
  static const Color darkAccent = Color(0xFFFFFFFF);
  static const Color darkAccentFg = Color(0xFF000000);

  // Pure White (Light Theme) Tokens
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF7F7F7);
  static const Color lightCardElevated = Color(0xFFEDEDED);
  static const Color lightBorder = Color(0xFFE2E2E2);
  static const Color lightBorderStrong = Color(0xFF000000);
  static const Color lightText = Color(0xFF000000);
  static const Color lightMuted = Color(0xFF666666);
  static const Color lightAccent = Color(0xFF000000);
  static const Color lightAccentFg = Color(0xFFFFFFFF);

  // Fintech / Security Accent Tokens (Inspired by Dribbble Fintech UI)
  static const Color electricBlue = Color(0xFF0E61FA);
  static const Color cyanGlow = Color(0xFF00C2FF);
  static const Color lockedMuted = Color(0xFF64748B);
  static const Color lockedAmber = Color(0xFFF59E0B);
  static const Color verifiedGreen = Color(0xFF10B981);
}

/// Theme generator and typographic helper for Z01auth.
class Z01Theme {
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Z01Colors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: Z01Colors.darkAccent,
        onPrimary: Z01Colors.darkAccentFg,
        surface: Z01Colors.darkCard,
        onSurface: Z01Colors.darkText,
        outline: Z01Colors.darkBorder,
      ),
      cardTheme: CardThemeData(
        color: Z01Colors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Z01Colors.darkBorder, width: 1),
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: Z01Colors.darkText,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: Z01Colors.darkText,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: Z01Colors.darkMuted,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Z01Colors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: Z01Colors.lightAccent,
        onPrimary: Z01Colors.lightAccentFg,
        surface: Z01Colors.lightCard,
        onSurface: Z01Colors.lightText,
        outline: Z01Colors.lightBorder,
      ),
      cardTheme: CardThemeData(
        color: Z01Colors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Z01Colors.lightBorder, width: 1),
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: Z01Colors.lightText,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: Z01Colors.lightText,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: Z01Colors.lightMuted,
        ),
      ),
    );
  }

  /// Monospace typography helper for timestamps, BSSID codes, and stats
  static TextStyle monoStyle({
    required BuildContext context,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Z01Colors.darkText : Z01Colors.lightText;

    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? defaultColor,
    );
  }
}
