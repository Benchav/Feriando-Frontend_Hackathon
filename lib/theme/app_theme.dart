import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cremaTortilla,
      primaryColor: AppColors.verdeMilpa,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.verdeMilpa,
        primary: AppColors.verdeMilpa,
        onPrimary: AppColors.textoSobreClaro,
        secondary: AppColors.verdeFresco,
        onSecondary: AppColors.textoSobreClaro,
        surface: AppColors.cremaTortilla,
        onSurface: AppColors.cafeTierra,
        error: AppColors.rojoTomate,
      ),
      fontFamily: AppTextStyles.cuerpo.fontFamily,
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.h1.copyWith(color: AppColors.cafeTierra),
        headlineMedium: AppTextStyles.h2.copyWith(color: AppColors.cafeTierra),
        titleLarge: AppTextStyles.h3.copyWith(color: AppColors.cafeTierra),
        bodyLarge: AppTextStyles.cuerpo.copyWith(color: AppColors.cafeTierra),
        bodyMedium: AppTextStyles.cuerpo.copyWith(color: AppColors.cafeTierra),
        labelLarge: AppTextStyles.boton.copyWith(color: AppColors.cafeTierra),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.verdeMilpa,
        foregroundColor: AppColors.textoSobreClaro,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.h3.copyWith(color: AppColors.textoSobreClaro),
        iconTheme: const IconThemeData(color: AppColors.textoSobreClaro),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.superficie,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.verdeMilpa, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.textoSecundario),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.verdeMilpa,
          foregroundColor: AppColors.textoSobreClaro,
          minimumSize: const Size.fromHeight(52),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
          textStyle: AppTextStyles.boton.copyWith(color: AppColors.textoSobreOscuro),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.verdeMilpa,
          side: const BorderSide(color: AppColors.verdeMilpa, width: 1.5),
          minimumSize: const Size.fromHeight(52),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
          textStyle: AppTextStyles.boton.copyWith(color: AppColors.verdeMilpa),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.cafeTierra,
        contentTextStyle: AppTextStyles.cuerpo.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.superficie,
        selectedItemColor: AppColors.verdeMilpa,
        unselectedItemColor: AppColors.textoSecundario,
        selectedLabelStyle: AppTextStyles.caption.copyWith(color: AppColors.verdeMilpa),
        unselectedLabelStyle: AppTextStyles.caption.copyWith(color: AppColors.textoSecundario),
        showUnselectedLabels: true,
        elevation: 12,
      ),
      dividerColor: AppColors.borde,
    );
  }
}
