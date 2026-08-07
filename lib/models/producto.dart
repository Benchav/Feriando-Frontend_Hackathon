class Producto {
  final int productoID;
  final String nombre;
  final String? descripcion;
  final double cantidad;
  final String unidadMedida;
  final String categoria;
  final String tipoOferta; // Trueque | Venta | Ambos
  final double? precioReferencial;
  final String estado; // Disponible | Reservado | Intercambiado | Inactivo
  final DateTime fechaPublicacion;
  final List<String> imagenes;
  final int usuarioID;
  final String nombreProductora;
  final String municipio;
  final String departamento;

  Producto({
    required this.productoID,
    required this.nombre,
    this.descripcion,
    required this.cantidad,
    required this.unidadMedida,
    required this.categoria,
    required this.tipoOferta,
    this.precioReferencial,
    required this.estado,
    required this.fechaPublicacion,
    required this.imagenes,
    required this.usuarioID,
    required this.nombreProductora,
    required this.municipio,
    required this.departamento,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        productoID: json['productoID'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
        cantidad: (json['cantidad'] ?? 0).toDouble(),
        unidadMedida: json['unidadMedida'] ?? '',
        categoria: json['categoria'] ?? '',
        tipoOferta: json['tipoOferta'] ?? 'Trueque',
        precioReferencial: json['precioReferencial']?.toDouble(),
        estado: json['estado'] ?? 'Disponible',
        fechaPublicacion: DateTime.tryParse(json['fechaPublicacion'] ?? '') ??
            DateTime.now(),
        imagenes: (json['imagenes'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
        usuarioID: json['usuarioID'],
        nombreProductora: json['nombreProductora'] ?? '',
        municipio: json['municipio'] ?? '',
        departamento: json['departamento'] ?? '',
      );
}

/// Cuerpo para crear/editar un producto (POST/PUT /api/productos)
class ProductoFormulario {
  int? categoriaID;
  String nombre;
  String? descripcion;
  double cantidad;
  int? unidadMedidaID;
  int? municipioID;
  String? direccionExacta;
  String tipoOferta;
  double? precioReferencial;
  List<String>? urlsImagenes;
  List<String>? imagenesArchivos;

  ProductoFormulario({
    this.categoriaID,
    this.nombre = '',
    this.descripcion,
    this.cantidad = 1,
    this.unidadMedidaID,
    this.municipioID,
    this.direccionExacta,
    this.tipoOferta = 'Trueque',
    this.precioReferencial,
    this.urlsImagenes,
    this.imagenesArchivos,
  });

  Map<String, dynamic> toCreateJson() => {
        'categoriaID': categoriaID,
        'nombre': nombre,
        'descripcion': descripcion,
        'cantidad': cantidad,
        'unidadMedidaID': unidadMedidaID,
        'municipioID': municipioID,
        'direccionExacta': direccionExacta,
        'tipoOferta': tipoOferta,
        'precioReferencial': precioReferencial,
        'urlsImagenes': urlsImagenes,
      };

  Map<String, dynamic> toUpdateJson() => {
        'nombre': nombre,
        'descripcion': descripcion,
        'cantidad': cantidad,
        'municipioID': municipioID,
        'direccionExacta': direccionExacta,
        'tipoOferta': tipoOferta,
        'precioReferencial': precioReferencial,
      };
}
