import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session_service.dart';

/// Excepción de la API con el mensaje que ya viene listo para mostrar
/// a la usuaria (el backend responde { "mensaje": "..." } en los errores).
class ApiException implements Exception {
  final String mensaje;
  final int? codigo;
  ApiException(this.mensaje, [this.codigo]);

  @override
  String toString() => mensaje;
}

class ApiClient {
  /// Emulador Android: 10.0.2.2 apunta al localhost de la PC.
  /// Celular físico por USB: usa la IP local de tu PC, ej. http://192.168.0.11:5080

static const String baseUrl = 'http://192.168.100.8.:5080/api';

  Future<Map<String, String>> _headers({bool conAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (conAuth) {
      final token = await SessionService.obtenerToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> get(String ruta, {bool conAuth = true}) async {
    final res = await http.get(Uri.parse('$baseUrl$ruta'), headers: await _headers(conAuth: conAuth));
    return _procesar(res);
  }

  Future<dynamic> post(String ruta, Map<String, dynamic> body, {bool conAuth = true}) async {
    final res = await http.post(
      Uri.parse('$baseUrl$ruta'),
      headers: await _headers(conAuth: conAuth),
      body: jsonEncode(body),
    );
    return _procesar(res);
  }

  Future<dynamic> put(String ruta, Map<String, dynamic> body, {bool conAuth = true}) async {
    final res = await http.put(
      Uri.parse('$baseUrl$ruta'),
      headers: await _headers(conAuth: conAuth),
      body: jsonEncode(body),
    );
    return _procesar(res);
  }

  Future<dynamic> delete(String ruta, {bool conAuth = true}) async {
    final res = await http.delete(Uri.parse('$baseUrl$ruta'), headers: await _headers(conAuth: conAuth));
    return _procesar(res);
  }

  dynamic _procesar(http.Response res) {
    final exito = res.statusCode >= 200 && res.statusCode < 300;
    final cuerpo = res.body.isNotEmpty ? jsonDecode(utf8.decode(res.bodyBytes)) : null;

    if (!exito) {
      final mensaje = (cuerpo is Map && cuerpo['mensaje'] != null)
          ? cuerpo['mensaje'] as String
          : 'Ocurrió un problema (código ${res.statusCode}). Intenta de nuevo.';
      throw ApiException(mensaje, res.statusCode);
    }
    return cuerpo;
  }
}
