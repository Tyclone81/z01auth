import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for Z01auth.
/// Palette: black, white, and ONE muted brand blue. No neon, no gradients.
class Z01Colors {
  // ---- Dark theme ----
  static const Color darkBg = Color(0xFF000000);
  static const Color darkCard = Color(0xFF0E0E0E);
  static const Color darkCardElevated = Color(0xFF1A1A1A);
  static const Color darkBorder = Color(0xFF262626);
  static const Color darkBorderStrong = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkMuted = Color(0xFF9A9A9A);
  static const Color darkAccent = Color(0xFFFFFFFF); // primary buttons
  static const Color darkAccentFg = Color(0xFF000000);

  // ---- Light theme ----
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF5F5F5);
  static const Color lightCardElevated = Color(0xFFEBEBEB);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightBorderStrong = Color(0xFF000000);
  static const Color lightText = Color(0xFF000000);
  static const Color lightMuted = Color(0xFF5E5E5E);
  static const Color lightAccent = Color(0xFF000000); // primary buttons
  static const Color lightAccentFg = Color(0xFFFFFFFF);

  // ---- The one brand colour (same in both themes) ----
  static const Color brand = Color(0xFF4A6FC4);
  static const Color onBrand = Color(0xFFFFFFFF);

  // ---- Old names kept so existing screens still compile ----
  // They now all map onto the three-colour palette.
  // TODO: replace these in the screens with brand / muted, then delete them.
  static const Color electricBlue = brand;
  static const Color cyanGlow = brand;
  static const Color verifiedGreen = brand;
  static const Color lockedMuted = Color(0xFF8A8A8A);
  static const Color lockedAmber = Color(0xFF8A8A8A);
}

/// Easy access to the right colours for the current theme.
/// Usage inside any build method:
///   final p = Z01Palette.of(context);
///   Container(color: p.card, child: Text('Hi', style: TextStyle(color: p.text)));
class Z01Palette {
  final Color bg, card, cardElevated, border, borderStrong;
  final Color text, muted, accent, accentFg;
  final Color brand = Z01Colors.brand;
  final Color onBrand = Z01Colors.onBrand;

  const Z01Palette._({
    required this.bg,
    required this.card,
    required this.cardElevated,
    required this.border,
    required this.borderStrong,
    required this.text,
    required this.muted,
    required this.accent,
    required this.accentFg,
  });

  static const Z01Palette dark = Z01Palette._(
    bg: Z01Colors.darkBg,
    card: Z01Colors.darkCard,
    cardElevated: Z01Colors.darkCardElevated,
    border: Z01Colors.darkBorder,
    borderStrong: Z01Colors.darkBorderStrong,
    text: Z01Colors.darkText,
    muted: Z01Colors.darkMuted,
    accent: Z01Colors.darkAccent,
    accentFg: Z01Colors.darkAccentFg,
  );

  static const Z01Palette light = Z01Palette._(
    bg: Z01Colors.lightBg,
    card: Z01Colors.lightCard,
    cardElevated: Z01Colors.lightCardElevated,
    border: Z01Colors.lightBorder,
    borderStrong: Z01Colors.lightBorderStrong,
    text: Z01Colors.lightText,
    muted: Z01Colors.lightMuted,
    accent: Z01Colors.lightAccent,
    accentFg: Z01Colors.lightAccentFg,
  );

  static Z01Palette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

/// Theme generator and typographic helper for Z01auth.
class Z01Theme {
  static ThemeData get darkTheme => _build(Brightness.dark);
  static ThemeData get lightTheme => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final p = isDark ? Z01Palette.dark : Z01Palette.light;

    final baseTextTheme = GoogleFonts.interTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).apply(bodyColor: p.text, displayColor: p.text);

    final pill = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(99),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: p.bg,
      colorScheme: (isDark ? const ColorScheme.dark() : const ColorScheme.light())
          .copyWith(
        primary: p.accent,
        onPrimary: p.accentFg,
        secondary: Z01Colors.brand,
        onSecondary: Z01Colors.onBrand,
        surface: p.card,
        onSurface: p.text,
        outline: p.border,
      ),
      cardTheme: CardThemeData(
        color: p.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: p.border, width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.accent,
          foregroundColor: p.accentFg,
          minimumSize: const Size.fromHeight(54),
          shape: pill,
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.text,
          minimumSize: const Size.fromHeight(54),
          side: BorderSide(color: p.border),
          shape: pill,
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: p.text,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: p.text,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: p.muted),
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