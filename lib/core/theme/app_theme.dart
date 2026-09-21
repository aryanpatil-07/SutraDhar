import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 11th-Century Chola Palette
  static const Color obsidian = Color(0xFF0A0D14);
  static const Color graniteDark = Color(0xFF121722);
  static const Color graniteCard = Color(0xFF18202F);
  static const Color graniteBorder = Color(0xFF2B374D);
  static const Color bronzePrimary = Color(0xFFD4A359);
  static const Color bronzeLight = Color(0xFFF3C77C);
  static const Color terracotta = Color(0xFFC24B38);
  static const Color verdigris = Color(0xFF2E8B8B);
  static const Color parchment = Color(0xFFEDE3D1);
  static const Color parchmentMuted = Color(0xFFA69B89);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: obsidian,
      primaryColor: bronzePrimary,
      colorScheme: const ColorScheme.dark(
        primary: bronzePrimary,
        secondary: verdigris,
        surface: graniteCard,
        error: terracotta,
        onPrimary: obsidian,
        onSurface: parchment,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cinzel(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: bronzeLight,
          letterSpacing: 1.5,
        ),
        displayMedium: GoogleFonts.cinzel(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: parchment,
          letterSpacing: 1.2,
        ),
        titleLarge: GoogleFonts.cinzel(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: bronzePrimary,
          letterSpacing: 1.1,
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: parchment,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 15,
          color: parchment,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 13,
          color: parchmentMuted,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: obsidian,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: bronzePrimary,
          foregroundColor: obsidian,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: bronzeLight, width: 1),
          ),
          textStyle: GoogleFonts.cinzel(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: bronzePrimary,
          side: const BorderSide(color: bronzePrimary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.cinzel(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: graniteCard,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: graniteBorder, width: 1),
        ),
      ),
    );
  }
}
