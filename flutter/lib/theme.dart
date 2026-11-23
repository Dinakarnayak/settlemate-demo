import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SettleMate colours, the same as the web app.
class AppColors {
  static const coral = Color(0xFFFF5A3C);
  static const sun = Color(0xFFFFC93C);
  static const blue = Color(0xFF3D6BFF);
  static const mint = Color(0xFF1FBF8F);
  static const pink = Color(0xFFFF7EB6);
  static const ink = Color(0xFF1B1D2E);
  static const mute = Color(0xFF6B6F86);
  static const bg = Color(0xFFFFFDFA);
  static const line = Color(0xFFF0E6DC);

  static const coralSoft = Color(0xFFFFE6DF);
  static const sunSoft = Color(0xFFFFF2CC);
  static const blueSoft = Color(0xFFE3EAFF);
  static const mintSoft = Color(0xFFD9F7EC);
  static const pinkSoft = Color(0xFFFFE3EF);

  static const tileBlue = Color(0xFFC9D6FF);
  static const tileSun = Color(0xFFFFE08A);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.coral,
      primary: AppColors.coral,
      secondary: AppColors.blue,
      surface: AppColors.bg,
    ),
    scaffoldBackgroundColor: AppColors.bg,
  );
  final body = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
    bodyColor: AppColors.ink,
    displayColor: AppColors.ink,
  );
  return base.copyWith(
    textTheme: body.copyWith(
      headlineMedium: GoogleFonts.fredoka(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.ink),
      titleLarge: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.ink),
      titleMedium: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.coral,
        minimumSize: const Size(44, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line, width: 1.5),
      ),
    ),
  );
}

/// Big rounded-number style used for figures like "17h" or "£155".
TextStyle bigNumber({double size = 32, Color color = AppColors.ink}) =>
    GoogleFonts.fredoka(fontSize: size, fontWeight: FontWeight.w600, color: color, height: 1);
