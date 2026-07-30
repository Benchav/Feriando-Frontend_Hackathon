import '../models/trueque.dart';
import 'api_client.dart';

class TruequeService {
  final ApiClient _api = ApiClient();

  /// CREATE — solicitar un trueque o compra
  Future<Trueque> solicitar({
    required int productoOfertadoID,
    int? productoSolicitadoID,
    double? montoAdicional,
    String? lugarEncuentro,
  }) async {
    final data = await _api.post('/trueques', {
      'productoOfertadoID': productoOfertadoID,
      'productoSolicitadoID': productoSolicitadoID,
      'montoAdicional': montoAdicional,
      'lugarEncuentro': lugarEncuentro,
    });
    return Trueque.fromJson(data);
  }

  /// UPDATE — aceptar o rechazar una solicitud recibida
  Future<Trueque> responder(int truequeID, {required bool aceptar, String? lugarEncuentro}) async {
    final data = await _api.put('/trueques/$truequeID/responder', {
      'accion': aceptar ? 'Aceptar' : 'Rechazar',
      'lugarEncuentro': lugarEncuentro,
    });
    return Trueque.fromJson(data);
  }

  /// READ — todas mis solicitudes (enviadas y recibidas)
  Future<List<Trueque>> mios() async {
    final data = await _api.get('/trueques/mios') as List;
    return data.map((e) => Trueque.fromJson(e)).toList();
  }

  /// CREATE — valorar a la otra persona tras el intercambio
  Future<void> valorar({required int truequeID, required int puntuacion, String? comentario}) async {
    await _api.post('/valoraciones', {
      'truequeID': truequeID,
      'puntuacion': puntuacion,
      'comentario': comentario,
    });
  }
}
