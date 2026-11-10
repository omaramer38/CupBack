import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===========================================================================
  // 1. Core Brand Colors (Airy Porcelain Canvas & Vibrant Roast Accents)
  // ===========================================================================
  static const Color creamWhite = Color(0xFFF9F7F4);      // Fresh, airy porcelain canvas (removes gloomy feel)
  static const Color offWhite = Color(0xFFF4EFEA);        // Subtle cashmere background for pills
  static const Color vanillaLatte = Color(0xFFE8E0D5);    // Delicate borders & dividers
  static const Color espressoBrown = Color(0xFF2C180E);   // Signature dark espresso brand tone
  static const Color caramelAccent = Color(0xFFD87D38);   // Vibrant appetizing amber caramel

  // ===========================================================================
  // 2. Refined Tonal Hierarchy (Specialty Coffee Palette)
  // ===========================================================================
  // Dark Roast Tones (High Contrast & Legibility)
  static const Color deepRoast = Color(0xFF190E08);       // Crisp rich dark roast for headers
  static const Color darkEspresso = Color(0xFF24140B);    // High-contrast primary text & dark banner surfaces
  static const Color mediumRoast = Color(0xFF5A3B28);     // Secondary subtitles
  static const Color coffeeMuted = Color(0xFF8E7767);     // Breathing metadata, captions

  // Pure White Surface Tones (Airy, Crisp & Modern)
  static const Color milkFoam = Color(0xFFFFFFFF);        // Pure white for cards to give light and air
  static const Color warmCream = Color(0xFFFAF7F2);       // Soft secondary canvas
  static const Color cardSurface = Color(0xFFFFFFFF);     // Crisp white elevated card surface
  static const Color cardSurfaceAlt = Color(0xFFF7F4EF);  // Subtle secondary container surface
  static const Color chipBackground = Color(0xFFF2ECE4);  // Filter chips & interactive pills

  // Caramel & Amber Accents
  static const Color caramelLight = Color(0xFFECA062);    // Lighter golden roast for highlights
  static const Color caramelDark = Color(0xFFB86224);     // Deep amber for button accents
  static const Color starGold = Color(0xFFF59E0B);        // Ratings star amber

  // Subtle Borders & Shadows
  static const Color borderSubtle = Color(0x1224140B);    // 7% subtle espresso border
  static const Color borderMedium = Color(0x2424140B);    // 14% espresso border
  static const Color dividerLight = Color(0x0E24140B);    // 5% subtle line divider

  // Semantic Status Colors
  static const Color success = Color(0xFF10B981);         // Fresh botanical green
  static const Color successSubtle = Color(0x1810B981);   // Soft green tint
  static const Color error = Color(0xFFEF4444);           // Vivid crimson error
  static const Color errorSubtle = Color(0x18EF4444);     // Soft error tint
  static const Color info = Color(0xFF3B82F6);            // Soft royal blue info
  static const Color infoSubtle = Color(0x183B82F6);      // Soft blue tint
  static const Color warning = Color(0xFFF59E0B);         // Warm amber warning
}
