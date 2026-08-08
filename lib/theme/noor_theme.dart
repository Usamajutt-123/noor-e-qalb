import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The visual language used throughout Noor-e-Qalb.
///
/// Keeping the colours in one place makes the dashboard and all feature
/// screens feel like one product instead of a collection of unrelated pages.
class NoorColors {
  static const background = Color(0xFF031F18);
  static const backgroundRaised = Color(0xFF062A20);
  static const panel = Color(0xFF07382B);
  static const panelRaised = Color(0xFF0A4635);
  static const panelSoft = Color(0xFF0B3025);
  static const gold = Color(0xFFD7AA3A);
  static const goldBright = Color(0xFFF0C95C);
  static const goldMuted = Color(0xFF9C792C);
  static const text = Color(0xFFF8F4E7);
  static const textMuted = Color(0xFFB2C3BA);
  static const textFaint = Color(0xFF718B80);
  static const success = Color(0xFF73C78F);
  static const danger = Color(0xFFE58B75);

  const NoorColors._();
}

class NoorTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: NoorColors.background,
      canvasColor: NoorColors.background,
      colorScheme: const ColorScheme.dark(
        primary: NoorColors.gold,
        onPrimary: NoorColors.background,
        secondary: NoorColors.goldBright,
        onSecondary: NoorColors.background,
        surface: NoorColors.panel,
        onSurface: NoorColors.text,
        error: NoorColors.danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: NoorColors.background,
        foregroundColor: NoorColors.text,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: NoorColors.backgroundRaised,
        selectedItemColor: NoorColors.goldBright,
        unselectedItemColor: NoorColors.textFaint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NoorColors.panelSoft,
        hintStyle: GoogleFonts.poppins(color: NoorColors.textFaint, fontSize: 12),
        labelStyle: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 12),
        prefixIconColor: NoorColors.gold,
        suffixIconColor: NoorColors.textMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NoorColors.goldMuted),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: NoorColors.gold.withOpacity(0.25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NoorColors.gold, width: 1.2),
        ),
      ),
      dividerTheme: const DividerThemeData(color: Color(0x1FFFFFFF), space: 1, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: NoorColors.panelRaised,
        contentTextStyle: GoogleFonts.poppins(color: NoorColors.text, fontSize: 12),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  const NoorTheme._();
}
