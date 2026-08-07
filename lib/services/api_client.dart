import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'session_service.dart';

/// Excepción de la API con un mensaje listo para mostrar a la usuaria.
class ApiException implements Exception {
  final String mensaje;
  final int? codigo;

  ApiException(this.mensaje, [this.codigo]);

  @override
  String toString() => mensaje;
}

class ApiClient {
  /// Dirección de la API.
  ///
  /// Para usar otra red sin editar código, ejecuta Flutter con:
  /// `--dart-define=API_BASE_URL=http://TU_IP:5080/api`
  /// La IP por defecto corresponde a la red configurada actualmente.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.100.8:5080/api',
  );

  Future<Map<String, String>> _headers({bool conAuth = true, bool multipart = false}) async {
    final headers = <String, String>{};
    if (!multipart) {
      headers['Content-Type'] = 'application/json';
    }
    if (conAuth) {
      final token = await SessionService.obtenerToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Uri _uri(String ruta) => Uri.parse('$baseUrl$ruta');

  Future<dynamic> get(String ruta, {bool conAuth = true}) async {
    final res = await http.get(_uri(ruta), headers: await _headers(conAuth: conAuth));
    return _procesar(res);
  }

  Future<dynamic> post(String ruta, Map<String, dynamic> body, {bool conAuth = true}) async {
    final res = await http.post(
      _uri(ruta),
      headers: await _headers(conAuth: conAuth),
      body: jsonEncode(body),
    );
    return _procesar(res);
  }

  Future<dynamic> put(String ruta, Map<String, dynamic> body, {bool conAuth = true}) async {
    final res = await http.put(
      _uri(ruta),
      headers: await _headers(conAuth: conAuth),
      body: jsonEncode(body),
    );
    return _procesar(res);
  }

  Future<dynamic> postMultipart(
    String ruta, {
    Map<String, String>? fields,
    List<File>? files,
    bool conAuth = true,
  }) async {
    final uri = _uri(ruta);
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await _headers(conAuth: conAuth, multipart: true));
    if (fields != null) {
      request.fields.addAll(fields);
    }
    if (files != null) {
      for (var file in files) {
        final multipartFile = await http.MultipartFile.fromPath('imagenes', file.path);
        request.files.add(multipartFile);
      }
    }
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    return _procesar(res);
  }

  Future<dynamic> putMultipart(
    String ruta, {
    Map<String, String>? fields,
    List<File>? files,
    bool conAuth = true,
  }) async {
    final uri = _uri(ruta);
    final request = http.MultipartRequest('PUT', uri);
    request.headers.addAll(await _headers(conAuth: conAuth, multipart: true));
    if (fields != null) {
      request.fields.addAll(fields);
    }
    if (files != null) {
      for (var file in files) {
        final multipartFile = await http.MultipartFile.fromPath('imagenes', file.path);
        request.files.add(multipartFile);
      }
    }
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    return _procesar(res);
  }

  Future<dynamic> delete(String ruta, {bool conAuth = true}) async {
    final res = await http.delete(_uri(ruta), headers: await _headers(conAuth: conAuth));
    return _procesar(res);
  }

  dynamic _procesar(http.Response res) {
    dynamic cuerpo;
    if (res.bodyBytes.isNotEmpty) {
      try {
        cuerpo = jsonDecode(utf8.decode(res.bodyBytes));
      } on FormatException {
        cuerpo = null;
      }
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      final mensaje = cuerpo is Map && cuerpo['mensaje'] != null
          ? cuerpo['mensaje'].toString()
          : 'Ocurrió un problema (código ${res.statusCode}). Intenta de nuevo.';
      throw ApiException(mensaje, res.statusCode);
    }
    return cuerpo;
  }
}
