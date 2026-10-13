import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Industrial SaaS Design System for TANDEM AI.
///
/// 60/30/10 Color Distribution Principle:
///   60% – Base Canvas: #090909 (bgDark), #0D0D0D (bgDarkAlt)
///   30% – Structured Surfaces: #141414 (surfaceDark), #191919 (cardDark), #292929 (cardBorder)
///   10% – Signal Accent: #E52430 (accentRed) — applied with restraint for primary actions and critical alerts
class AppTheme {
  // ─── 60% FOUNDATION ───────────────────────────────────────────────────────
  static const Color bgDark = Color(0xFF090909);
  static const Color bgDarkAlt = Color(0xFF0E0E0E);

  // ─── 30% SURFACES & BORDERS ───────────────────────────────────────────────
  static const Color surfaceDark = Color(0xFF141414);
  static const Color cardDark = Color(0xFF191919);
  static const Color cardDarkElevated = Color(0xFF1E1E1E);
  static const Color cardBorder = Color(0xFF292929);
  static const Color cardBorderGlow = Color(0xFF383838);
  static const Color dividerColor = Color(0xFF242424);

  // ─── 10% PRIMARY SIGNAL ACCENT ────────────────────────────────────────────
  static const Color accentRed = Color(0xFFE52430);
  static const Color accentRedDim = Color(0xFF2A0D10);
  static const Color accentRedHover = Color(0xFFF03542);

  // ─── SEMANTIC STATUS ──────────────────────────────────────────────────────
  static const Color amberWarning = Color(0xFFF59E0B);
  static const Color amberWarningDim = Color(0xFF2A1E0B);
  static const Color greenCompliant = Color(0xFF22C55E);
  static const Color greenCompliantDim = Color(0xFF0D2517);
  static const Color redViolation = Color(0xFFE52430);
  static const Color blueInfo = Color(0xFF3B82F6);

  // ─── TYPOGRAPHY TOKENS ────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF71717A);

  // ─── LEGACY COMPATIBILITY ALIASES ─────────────────────────────────────────
  static const Color cyanAccent = accentRed;
  static const Color blueAccent = accentRed;

  // ─── SUBTLE GRADIENTS ─────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE52430), Color(0xFFC01822)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient logoGradient = LinearGradient(
    colors: [Color(0xFFE52430), Color(0xFF8B1218)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiBadgeGradient = LinearGradient(
    colors: [Color(0xFFE52430), Color(0xFFB51B24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── SPACING SCALE ────────────────────────────────────────────────────────
  static const double sp4 = 4.0;
  static const double sp8 = 8.0;
  static const double sp12 = 12.0;
  static const double sp16 = 16.0;
  static const double sp20 = 20.0;
  static const double sp24 = 24.0;
  static const double sp32 = 32.0;
  static const double sp40 = 40.0;
  static const double sp48 = 48.0;

  // ─── CORNER RADII ─────────────────────────────────────────────────────────
  static const double radiusSm = 4.0;
  static const double radiusMd = 6.0;
  static const double radiusLg = 8.0;
  static const double radiusXl = 12.0;
  static const double radiusCard = 6.0;

  // ─── GLOBAL THEME DATA ────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: accentRed,
      colorScheme: const ColorScheme.dark(
        primary: accentRed,
        secondary: accentRed,
        surface: surfaceDark,
        error: redViolation,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(color: cardBorder),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: accentRed, width: 1.5),
        ),
        hintStyle: const TextStyle(fontSize: 13, color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentRed,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: cardBorder),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ─── TYPOGRAPHY HELPERS ───────────────────────────────────────────────────
  static TextStyle displayStyle({
    double fontSize = 32,
    FontWeight fontWeight = FontWeight.w800,
    Color color = textPrimary,
    double letterSpacing = -0.5,
  }) {
    return GoogleFonts.barlow(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.15,
    );
  }

  static TextStyle monoStyle({
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.w500,
    Color color = textSecondary,
    double letterSpacing = 0.4,
  }) {
    return GoogleFonts.ibmPlexMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // ─── DECORATIONS ──────────────────────────────────────────────────────────
  static BoxDecoration panelDecoration({
    Color? color,
    bool redBorder = false,
  }) {
    final borderColor = redBorder ? accentRed.withValues(alpha: 0.5) : cardBorder;
    return BoxDecoration(
      color: color ?? cardDark,
      borderRadius: BorderRadius.circular(radiusCard),
      border: Border.all(color: borderColor, width: redBorder ? 1.5 : 1),
    );
  }

  static BoxDecoration tagDecoration(Color color) => BoxDecoration(
    color: color.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(radiusSm),
    border: Border.all(color: color.withValues(alpha: 0.35)),
  );
}
