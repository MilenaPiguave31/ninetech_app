import 'package:flutter/material.dart';

// Aquí guardamos todos los colores que usaremos en la aplicación.
// Coinciden 1 a 1 con las variables CSS del prototipo HTML.
class AppColors {
  static const Color pink = Color(0xFFE8528A);
  static const Color pinkLight = Color(0xFFFCE8F2);
  static const Color pinkMid = Color(0xFFF4A7C9);

  static const Color purple = Color(0xFF7C5CBF);
  static const Color purpleLight = Color(0xFFEDE8F8);

  static const Color blue = Color(0xFF4A90D9);
  static const Color blueLight = Color(0xFFE8F3FD);

  static const Color teal = Color(0xFF2BAE82);
  static const Color tealLight = Color(0xFFE3F8F1);

  static const Color amber = Color(0xFFF5A623);
  static const Color amberLight = Color(0xFFFFF3E0);

  static const Color dark = Color(0xFF1E1232);
  static const Color gray = Color(0xFF7A7A9A);
  static const Color background = Color(0xFFFAF8FF);
}

// Aquí configuramos el estilo general de toda la aplicación.
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.purple),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.dark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.pink, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pink,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
    );
  }
}
