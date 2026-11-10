import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.tajawal().fontFamily,
      scaffoldBackgroundColor: AppColors.creamWhite,
      primaryColor: AppColors.espressoBrown,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.espressoBrown,
        onPrimary: Colors.white,
        secondary: AppColors.caramelAccent,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppColors.milkFoam,
        onSurface: AppColors.deepRoast,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.creamWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.deepRoast),
        titleTextStyle: TextStyle(
          color: AppColors.deepRoast,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 0.8,
        space: 20,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepRoast,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class AppDecorations {
  AppDecorations._();

  static final BorderRadius radiusSm = BorderRadius.circular(12);
  static final BorderRadius radiusMd = BorderRadius.circular(18);
  static final BorderRadius radiusLg = BorderRadius.circular(24);
  static final BorderRadius radiusPill = BorderRadius.circular(36);

  static final List<BoxShadow> softCardShadow = [
    BoxShadow(
      color: const Color(0xFF190E08).withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF190E08).withValues(alpha: 0.02),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static final List<BoxShadow> elevatedCardShadow = [
    BoxShadow(
      color: const Color(0xFF190E08).withValues(alpha: 0.08),
      blurRadius: 22,
      offset: const Offset(0, 6),
    ),
  ];

  static final List<BoxShadow> floatingNavShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.07),
      blurRadius: 24,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];
}
