import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFD85A32);
  static const Color backgroundLight = Color(0xFFF6F3ED);
  static const Color cardBackground = Colors.white;
  static const Color textDark = Color(0xFF2D2727);
  static const Color textMuted = Color(0xFF8C827A);
  
  // Colores de estado
  static const Color statusOrangeBg = Color(0xFFFDF0ED);
  static const Color statusBlueBg = Color(0xFFE8F4F8);
  static const Color statusGreenBg = Color(0xFFEAF5EE);
  
  static const Color statusBlueText = Color(0xFF2980B9);
  static const Color statusGreenText = Color(0xFF27AE60);

  static ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: backgroundLight,
      primaryColor: primaryOrange,
      fontFamily: 'Roboto', // O la fuente usada en tu Figma
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryOrange,
        background: backgroundLight,
      ),
    );
  }
}