import '../models/catalogos.dart';
import 'api_client.dart';

class CatalogoService {
  final ApiClient _api = ApiClient();

  /// Obtiene los departamentos con sus municipios anidados
  Future<List<Departamento>> departamentos() async {
    final data = await _api.get('/catalogos/departamentos', conAuth: false) as List;
    return data.map((e) => Departamento.fromJson(e)).toList();
  }

  /// Obtiene los municipios (opcionalmente filtrados por departamentoID)
  Future<List<Municipio>> municipios({int? departamentoID}) async {
    String endpoint = '/catalogos/municipios';
    if (departamentoID != null) {
      endpoint += '?departamentoId=$departamentoID';
    }
    final data = await _api.get(endpoint, conAuth: false) as List;
    return data.map((e) => Municipio.fromJson(e)).toList();
  }

  Future<List<Categoria>> categorias() async {
    final data = await _api.get('/catalogos/categorias', conAuth: false) as List;
    return data.map((e) => Categoria.fromJson(e)).toList();
  }

  Future<List<UnidadMedida>> unidadesMedida() async {
    final data = await _api.get('/catalogos/unidades-medida', conAuth: false) as List;
    return data.map((e) => UnidadMedida.fromJson(e)).toList();
  }

  Future<List<Idioma>> idiomas() async {
    final data = await _api.get('/catalogos/idiomas', conAuth: false) as List;
    return data.map((e) => Idioma.fromJson(e)).toList();
  }
}