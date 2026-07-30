import '../models/trueque.dart';
import 'api_client.dart';

class NotificacionService {
  final ApiClient _api = ApiClient();

  Future<List<Notificacion>> listar({bool soloNoLeidas = false}) async {
    final data = await _api.get('/notificaciones?soloNoLeidas=$soloNoLeidas') as List;
    return data.map((e) => Notificacion.fromJson(e)).toList();
  }

  Future<void> marcarLeida(int id) async {
    await _api.put('/notificaciones/$id/leida', {});
  }
}
