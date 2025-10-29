import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData buildAppTheme() {
    final base = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      textTheme: Typography.material2021().black,
      useMaterial3: true,
    );

    final textTheme = GoogleFonts.breeSerifTextTheme().copyWith(
      displayLarge: GoogleFonts.breeSerif(fontSize: 36, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.breeSerif(fontSize: 30, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.breeSerif(fontSize: 24, fontWeight: FontWeight.w600),
      headlineLarge: GoogleFonts.breeSerif(fontSize: 22, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.breeSerif(fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.breeSerif(fontSize: 18, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.breeSerif(fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.breeSerif(fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.breeSerif(fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.breeSerif(fontSize: 16),
      bodyMedium: GoogleFonts.breeSerif(fontSize: 14),
      bodySmall: GoogleFonts.breeSerif(fontSize: 12),
      labelLarge: GoogleFonts.breeSerif(fontSize: 14, fontWeight: FontWeight.w500),
    );

    final coloredTextTheme = textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return base.copyWith(
      textTheme: coloredTextTheme,
      appBarTheme: base.appBarTheme.copyWith(backgroundColor: Colors.transparent, elevation: 0),
      scaffoldBackgroundColor: AppColors.scaffoldOverlay,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          textStyle: coloredTextTheme.titleMedium,
        ),
      ),
    );
  }
}
