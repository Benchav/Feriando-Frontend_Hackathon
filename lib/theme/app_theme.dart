import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.fondo,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.verdeMilpa,
        primary: AppColors.verdeMilpa,
        secondary: AppColors.anil,
        error: AppColors.error,
        surface: AppColors.superficie,
      ),
      fontFamily: AppTextStyles.cuerpo.fontFamily,
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.h1,
        headlineMedium: AppTextStyles.h2,
        titleLarge: AppTextStyles.h3,
        bodyLarge: AppTextStyles.cuerpo,
        bodyMedium: AppTextStyles.cuerpo,
        labelLarge: AppTextStyles.boton,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.verdeMilpa,
        foregroundColor: AppColors.textoSobreOscuro,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.h3.copyWith(color: AppColors.textoSobreOscuro),
      ),
      cardTheme: CardThemeData(
        color: AppColors.superficie,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borde, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.superficie,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.verdeMilpa, width: 2),
        ),
        labelStyle: AppTextStyles.cuerpo.copyWith(color: AppColors.textoSecundario),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.verdeMilpa,
          foregroundColor: AppColors.textoSobreOscuro,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: AppTextStyles.boton,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.verdeMilpa,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.verdeMilpa, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: AppTextStyles.boton.copyWith(color: AppColors.verdeMilpa),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.superficie,
        selectedItemColor: AppColors.verdeMilpa,
        unselectedItemColor: AppColors.textoSecundario,
        selectedLabelStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.caption,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textoPrimario,
        contentTextStyle: AppTextStyles.cuerpo.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerColor: AppColors.borde,
    );
  }
}
