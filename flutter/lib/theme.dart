import 'package:flutter/material.dart';

/// Landed colours, the same as the web app. Fonts are bundled in the app
/// (assets/fonts) so nothing is downloaded at runtime.
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
  static const sunText = Color(0xFF8A6100);
}

const bodyFont = 'PlusJakartaSans';
const displayFont = 'Fredoka';

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: bodyFont,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.coral,
      primary: AppColors.coral,
      secondary: AppColors.blue,
      surface: AppColors.bg,
    ),
    scaffoldBackgroundColor: AppColors.bg,
  );
  TextStyle display(double size) =>
      TextStyle(fontFamily: displayFont, fontSize: size, fontWeight: FontWeight.w600, color: AppColors.ink);
  return base.copyWith(
    textTheme: base.textTheme
        .apply(bodyColor: AppColors.ink, displayColor: AppColors.ink, fontFamily: bodyFont)
        .copyWith(
          headlineMedium: display(28),
          titleLarge: display(20),
          titleMedium: display(18),
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontFamily: displayFont, fontSize: 21, fontWeight: FontWeight.w600, color: AppColors.ink),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.coral,
        foregroundColor: Colors.white,
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontFamily: bodyFont, fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        minimumSize: const Size(48, 48),
        side: const BorderSide(color: AppColors.line, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontFamily: bodyFont, fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      labelStyle: const TextStyle(fontFamily: bodyFont, fontWeight: FontWeight.w600, color: AppColors.ink),
      side: const BorderSide(color: AppColors.line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.coral, width: 2),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ink,
      contentTextStyle: const TextStyle(fontFamily: bodyFont, fontWeight: FontWeight.w700, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}

/// Big rounded-number style used for figures like "17h" or "£155".
TextStyle bigNumber({double size = 32, Color color = AppColors.ink}) =>
    TextStyle(fontFamily: displayFont, fontSize: size, fontWeight: FontWeight.w600, color: color, height: 1);
