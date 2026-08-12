class Departamento {
  final int departamentoID;
  final String nombre;
  final List<Municipio> municipios;

  Departamento({
    required this.departamentoID,
    required this.nombre,
    required this.municipios,
  });

  factory Departamento.fromJson(Map<String, dynamic> json) => Departamento(
        departamentoID: json['departamentoID'],
        nombre: json['nombre'],
        municipios: (json['municipios'] as List<dynamic>?)
                ?.map((m) => Municipio.fromJson(m))
                .toList() ??
            [],
      );

  @override
  String toString() => nombre;
}

class Municipio {
  final int municipioID;
  final String nombre;
  final int? departamentoID;
  final String? departamento;

  Municipio({
    required this.municipioID,
    required this.nombre,
    this.departamentoID,
    this.departamento,
  });

  factory Municipio.fromJson(Map<String, dynamic> json) => Municipio(
        municipioID: json['municipioID'],
        nombre: json['nombre'],
        departamentoID: json['departamentoID'],
        departamento: json['departamento'],
      );

  @override
  String toString() =>
      '$nombre${departamento != null ? ', $departamento' : ''}';
}

class Categoria {
  final int categoriaID;
  final String nombre;
  final String? descripcion;

  Categoria({
    required this.categoriaID,
    required this.nombre,
    this.descripcion,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        categoriaID: json['categoriaID'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
      );

  @override
  String toString() => nombre;
}

class UnidadMedida {
  final int unidadMedidaID;
  final String nombre;
  final String? abreviatura;

  UnidadMedida({
    required this.unidadMedidaID,
    required this.nombre,
    this.abreviatura,
  });

  factory UnidadMedida.fromJson(Map<String, dynamic> json) => UnidadMedida(
        unidadMedidaID: json['unidadMedidaID'],
        nombre: json['nombre'],
        abreviatura: json['abreviatura'],
      );

  @override
  String toString() => abreviatura != null ? '$nombre ($abreviatura)' : nombre;
}

class Idioma {
  final int idiomaID;
  final String nombre;
  final String codigo;

  const Idioma({
    required this.idiomaID,
    required this.nombre,
    required this.codigo,
  });

  factory Idioma.fromJson(Map<String, dynamic> json) => Idioma(
        idiomaID: json['idiomaID'],
        nombre: json['nombre'],
        codigo: json['codigo'] ?? '',
      );

  @override
  String toString() => nombre;
}