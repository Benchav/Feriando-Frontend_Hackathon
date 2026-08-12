import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";
import '../models/usuario.dart';

/// Guarda el token JWT y los datos de la usuaria en el dispositivo,
/// para que la sesión sobreviva a cerrar y abrir la app.
class SessionService {
  static const _claveToken = 'el_trueque_token';
  static const _claveUsuario = 'el_trueque_usuario';
  static const _claveIdiomaPreferido = 'el_trueque_idioma_preferido';

  static Future<void> guardarSesion(String token, Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveToken, token);
    await prefs.setString(_claveUsuario, jsonEncode(usuario.toJson()));
  }

  static Future<void> guardarIdiomaPreferidoID(int idiomaID) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveIdiomaPreferido, idiomaID);
  }

  static Future<int?> obtenerIdiomaPreferidoID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_claveIdiomaPreferido);
  }

  static Future<String?> obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_claveToken);
  }

  static Future<Usuario?> obtenerUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_claveUsuario);
    if (data == null) return null;
    return Usuario.fromJson(jsonDecode(data));
  }

  static Future<void> guardarUsuario(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_claveToken);
    if (token != null) {
      await prefs.setString(_claveUsuario, jsonEncode(usuario.toJson()));
    } else {
      throw StateError('No se encontró un token de sesión para actualizar el usuario.');
    }
  }

  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_claveToken);
    await prefs.remove(_claveUsuario);
  }
}
