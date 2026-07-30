import 'package:flutter/material.dart';

/// Paleta de "El Trueque".
/// Inspirada en la milpa, el añil de los tejidos y el achiote del mercado
/// campesino, con alto contraste para buena legibilidad al aire libre.
class AppColors {
  AppColors._();

  // Marca
  static const Color verdeMilpa = Color(0xFF4F7A5B); // primario
  static const Color verdeMilpaSuave = Color(0xFFE4EFE1); // fondo/realce primario
  static const Color achiote = Color(0xFFE0873B); // acento cálido (trueque)
  static const Color anil = Color(0xFF3D5A73); // acento frío (secundario)
  static const Color rosaCadena = Color(0xFFD66E86); // acento enfoque de género

  // Base
  static const Color fondo = Color(0xFFFBF7F1); // fondo general (scaffold)
  static const Color superficie = Color(0xFFFFFFFF); // tarjetas
  static const Color borde = Color(0xFFE3D9CC); // divisores, bordes suaves

  // Texto
  static const Color textoPrimario = Color(0xFF3B2F2A);
  static const Color textoSecundario = Color(0xFF8A7F74);
  static const Color textoSobreOscuro = Color(0xFFFFFFFF);

  // Estados
  static const Color exito = Color(0xFF4F7A5B); // reutiliza verde milpa
  static const Color advertencia = Color(0xFFE0873B); // reutiliza achiote
  static const Color error = Color(0xFFB5473A);

  // Estados de un producto (coherentes con la base de datos)
  static const Color estadoDisponible = verdeMilpa;
  static const Color estadoReservado = achiote;
  static const Color estadoIntercambiado = anil;
  static const Color estadoInactivo = textoSecundario;
}
