import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Ascentez-inspired industrial design tokens.
///
/// Color distribution (60 / 30 / 10):
///   60% – near-black canvas   : bgDark (#090909), bgDarkAlt (#0D0D0D)
///   30% – charcoal surfaces   : surfaceDark (#141414), cardDark (#1D1D1D)
///   10% – signal-red accent   : accentRed (#E3262E)  — used sparingly
///
/// No additional accent colours. No gradients on app surfaces.
/// Box-shadows only when strictly needed for elevation hierarchy.
class AppTheme {
  // ─── 60% FOUNDATION ───────────────────────────────────────────────────────
  static const Color bgDark    = Color(0xFF090909);
  static const Color bgDarkAlt = Color(0xFF0D0D0D);

  // ─── 30% SUPPORTING SURFACES ──────────────────────────────────────────────
  static const Color surfaceDark    = Color(0xFF141414);
  static const Color cardDark       = Color(0xFF1D1D1D);
  static const Color cardBorder     = Color(0xFF2A2A2A);
  static const Color cardBorderGlow = Color(0xFF333333); // slightly brighter hairline

  // ─── 10% SIGNAL RED ACCENT ────────────────────────────────────────────────
  static const Color accentRed    = Color(0xFFE3262E);
  static const Color accentRedDim = Color(0xFF8B1419); // for fills / backgrounds

  // ─── SEMANTIC STATUS COLOURS ──────────────────────────────────────────────
  static const Color amberWarning  = Color(0xFFF59E0B);
  static const Color greenCompliant = Color(0xFF22C55E);
  static const Color redViolation  = Color(0xFFE3262E); // same as accentRed
  static const Color purpleAi      = Color(0xFF8B5CF6);

  // ─── LEGACY ALIASES ───────────────────────────────────────────────────────
  // These map old cyan/blue call-sites to the correct industrial tokens so
  // every widget compiles without change.
  static const Color cyanAccent  = accentRed;
  static const Color blueAccent  = accentRed;

  // ─── TEXT ─────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFA6A6A6);
  static const Color textMuted     = Color(0xFF6B6B6B);

  // ─── DIVIDER ──────────────────────────────────────────────────────────────
  static const Color dividerColor = Color(0xFF242424);

  // ─── GRADIENTS ────────────────────────────────────────────────────────────
  // Kept as very subtle charcoal-to-charcoal transitions — NOT blue or cyan.
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF141414), Color(0xFF191919)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE3262E), Color(0xFFB91C24)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient violationGradient = LinearGradient(
    colors: [Color(0xFFE3262E), Color(0xFFB91C24)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient aiBadgeGradient = LinearGradient(
    colors: [Color(0xFFE3262E), Color(0xFFB91C24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── 4 px BASE SPACING SCALE ──────────────────────────────────────────────
  static const double sp4  = 4;
  static const double sp8  = 8;
  static const double sp12 = 12;
  static const double sp16 = 16;
  static const double sp20 = 20;
  static const double sp24 = 24;
  static const double sp32 = 32;
  static const double sp40 = 40;
  static const double sp48 = 48;

  // ─── BORDER RADIUS SCALE ──────────────────────────────────────────────────
  static const double radiusSharp = 2;
  static const double radiusSm    = 4;
  static const double radiusMd    = 6;
  static const double radiusLg    = 8;
  static const double radiusCard  = 4;

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
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: accentRed, width: 1.5),
        ),
        hintStyle: const TextStyle(fontSize: 13, color: textMuted),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardDark,
        selectedColor: accentRed.withValues(alpha: 0.15),
        labelStyle: const TextStyle(fontSize: 11, color: textSecondary),
        side: const BorderSide(color: cardBorder),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentRed,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusLg)),
          textStyle: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textSecondary,
          side: const BorderSide(color: cardBorder),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusLg)),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }

  // ─── DISPLAY / HEADING STYLE ──────────────────────────────────────────────
  /// Bold slightly-condensed display text — used for page titles and major figures.
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
      height: 1.1,
    );
  }

  // ─── MONOSPACE LABEL STYLE ────────────────────────────────────────────────
  /// Short uppercase mono labels — metadata, status captions, table headers.
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

  // ─── DECORATION HELPERS ───────────────────────────────────────────────────

  /// Flat surface card decoration. Pass [redBorder] for critical-status panels.
  static BoxDecoration panelDecoration({
    Color? color,
    bool redBorder = false,
  }) {
    final borderColor =
        redBorder ? accentRed.withValues(alpha: 0.5) : cardBorder;
    return BoxDecoration(
      color: color ?? cardDark,
      borderRadius: BorderRadius.circular(radiusCard),
      border: Border.all(color: borderColor, width: redBorder ? 1.5 : 1),
    );
  }

  /// Small tag / status badge decoration — tinted fill + matching border.
  static BoxDecoration tagDecoration(Color color) => BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      );
}
