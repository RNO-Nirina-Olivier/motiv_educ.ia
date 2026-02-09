import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motiv_educ/core/constants/app_constants.dart';

class ThemeService {
  static late SharedPreferences _prefs;
  
  // Thème Clair
  static ThemeData get lightTheme {
    return ThemeData(
      // Couleurs principales
      primaryColor: const Color(0xFF2196F3),
      primaryColorLight: const Color(0xFF64B5F6),
      primaryColorDark: const Color(0xFF1976D2),
      
      // Schéma de couleurs
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2196F3),
        secondary: Color(0xFF4CAF50),
        background: Color(0xFFF5F5F5),
        surface: Colors.white,
        onBackground: Colors.black,
        onSurface: Colors.black,
      ),
      
      // Arrière-plan
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      // backgroundColor: const Color(0xFFFFFFFF),
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      
      // Cartes
//     cardTheme: const CardTheme(
//   elevation: 2,
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.all(Radius.circular(12)),
//   ),
//   color: Colors.white,
//   margin: const EdgeInsets.all(8),
//   clipBehavior: Clip.antiAlias,
// ),
      
      // Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Champs de saisie
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Inter',
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Inter',
        ),
      ),
      
      // Typographie
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          fontSize: 32,
          color: Colors.black,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Colors.black,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Colors.black87,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: Colors.black54,
        ),
      ),
      
      // Icônes
      iconTheme: const IconThemeData(
        color: Color(0xFF2196F3),
      ),
    );
  }
  
  // Thème Sombre
  static ThemeData get darkTheme {
    return ThemeData(
      // Couleurs principales
      primaryColor: const Color(0xFF2196F3),
      primaryColorLight: const Color(0xFF64B5F6),
      primaryColorDark: const Color(0xFF1976D2),
      
      // Schéma de couleurs
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF2196F3),
        secondary: Color(0xFF4CAF50),
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      
      // Arrière-plan
      scaffoldBackgroundColor: const Color(0xFF121212),
      // backgroundColor: const Color(0xFF1E1E1E),
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      
      // Cartes
      // cardTheme: const CardTheme(
      //   elevation: 2,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(12)),
      //   ),
      //   color: Color(0xFF1E1E1E),
      //   margin: EdgeInsets.all(8),
      //   clipBehavior: Clip.antiAlias,
      // ),
      
      // Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Champs de saisie
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Inter',
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Inter',
        ),
      ),
      
      // Typographie
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          fontSize: 32,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: Colors.white70,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Colors.white70,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: Colors.white54,
        ),
      ),
      
      // Icônes
      iconTheme: const IconThemeData(
        color: Color(0xFF2196F3),
      ),
      
      // Brightness
      brightness: Brightness.dark,
    );
  }
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static ThemeData getCurrentTheme() {
    final themeMode = _prefs.getString(AppConstants.themeKey) ?? 'light';
    return themeMode == 'dark' ? darkTheme : lightTheme;
  }
  
  static Future<void> setTheme(String theme) async {
    await _prefs.setString(AppConstants.themeKey, theme);
  }
  
  static bool get isDarkMode {
    final themeMode = _prefs.getString(AppConstants.themeKey) ?? 'light';
    return themeMode == 'dark';
  }
  
  static Future<void> toggleTheme() async {
    final currentTheme = _prefs.getString(AppConstants.themeKey) ?? 'light';
    final newTheme = currentTheme == 'light' ? 'dark' : 'light';
    await setTheme(newTheme);
  }
}