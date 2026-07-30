import '../models/usuario.dart';
import 'api_client.dart';
import 'session_service.dart';

class AuthService {
  final ApiClient _api = ApiClient();

  Future<Usuario> registro({
    required String nombres,
    required String apellidos,
    required String telefono,
    String? correo,
    required String password,
    String? genero,
    required int municipioID, // <--- Actualizado
    required String direccionExacta, // <--- Agregado
    int? idiomaPreferidoID,
    bool esProductora = true,
  }) async {
    final data = await _api.post('/auth/registro', {
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'correo': correo,
      'password': password,
      'genero': genero,
      'municipioID': municipioID, // <--- Actualizado
      'direccionExacta': direccionExacta, // <--- Agregado
      'idiomaPreferidoID': idiomaPreferidoID,
      'esProductora': esProductora,
    }, conAuth: false);

    final usuario = Usuario.fromJson(data['usuario']);
    await SessionService.guardarSesion(data['token'], usuario);
    return usuario;
  }

  Future<Usuario> login({required String telefono, required String password}) async {
    final data = await _api.post('/auth/login', {
      'telefono': telefono,
      'password': password,
    }, conAuth: false);

    final usuario = Usuario.fromJson(data['usuario']);
    await SessionService.guardarSesion(data['token'], usuario);
    return usuario;
  }

  Future<void> logout() => SessionService.cerrarSesion();
}