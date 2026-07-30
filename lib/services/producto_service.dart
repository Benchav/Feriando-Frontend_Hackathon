import '../models/producto.dart';
import 'api_client.dart';

class ProductoService {
  final ApiClient _api = ApiClient();

  /// READ — catálogo público con filtros opcionales
  Future<List<Producto>> listar({
    int? categoriaID,
    int? departamentoID, // <--- Actualizado
    int? municipioID,    // <--- Actualizado
    String? tipoOferta,
    String? busqueda,
    String estado = 'Disponible',
  }) async {
    final query = <String, String>{'estado': estado};
    if (categoriaID != null) query['categoriaID'] = '$categoriaID';
    if (departamentoID != null) query['departamentoID'] = '$departamentoID';
    if (municipioID != null) query['municipioID'] = '$municipioID';
    if (tipoOferta != null) query['tipoOferta'] = tipoOferta;
    if (busqueda != null && busqueda.isNotEmpty) query['busqueda'] = busqueda;

    final qs = Uri(queryParameters: query).query;
    final data = await _api.get('/productos?$qs', conAuth: false) as List;
    return data.map((e) => Producto.fromJson(e)).toList();
  }

  /// READ — detalle de un producto
  Future<Producto> obtener(int id) async {
    final data = await _api.get('/productos/$id', conAuth: false);
    return Producto.fromJson(data);
  }

  /// READ — productos publicados por la usuaria autenticada
  Future<List<Producto>> mios() async {
    final data = await _api.get('/productos/mios') as List;
    return data.map((e) => Producto.fromJson(e)).toList();
  }

  /// CREATE
  Future<Producto> crear(ProductoFormulario formulario) async {
    final data = await _api.post('/productos', formulario.toCreateJson());
    return Producto.fromJson(data);
  }

  /// UPDATE
  Future<void> actualizar(int id, ProductoFormulario formulario) async {
    await _api.put('/productos/$id', formulario.toUpdateJson());
  }

  /// UPDATE rápido — cambiar solo el estado (ej. marcar Inactivo)
  Future<void> cambiarEstado(int id, String nuevoEstado) async {
    await _api.put('/productos/$id', {'estado': nuevoEstado});
  }

  /// DELETE
  Future<void> eliminar(int id) async {
    await _api.delete('/productos/$id');
  }
}