import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Escala tipográfica de "El Trueque".
/// Tamaños grandes y alto contraste: pensada para usuarias con distintos
/// niveles de alfabetización digital, leyendo muchas veces bajo sol directo.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _titulo({required double size, required FontWeight peso, Color? color}) =>
      GoogleFonts.baloo2(fontSize: size, fontWeight: peso, color: color ?? AppColors.textoPrimario);

  static TextStyle _cuerpo({required double size, required FontWeight peso, Color? color}) =>
      GoogleFonts.workSans(fontSize: size, fontWeight: peso, color: color ?? AppColors.textoPrimario);

  static TextStyle h1 = _titulo(size: 28, peso: FontWeight.w700);
  static TextStyle h2 = _titulo(size: 22, peso: FontWeight.w700);
  static TextStyle h3 = _titulo(size: 18, peso: FontWeight.w600);

  static TextStyle cuerpo = _cuerpo(size: 16, peso: FontWeight.w400);
  static TextStyle cuerpoDestacado = _cuerpo(size: 16, peso: FontWeight.w600);
  static TextStyle etiqueta = _cuerpo(size: 13, peso: FontWeight.w600, color: AppColors.textoSecundario);
  static TextStyle caption = _cuerpo(size: 12, peso: FontWeight.w400, color: AppColors.textoSecundario);
  static TextStyle boton = _cuerpo(size: 16, peso: FontWeight.w600, color: AppColors.textoPrimario);
}
