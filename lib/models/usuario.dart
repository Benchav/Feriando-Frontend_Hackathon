class Usuario {
  final int usuarioID;
  final String nombres;
  final String apellidos;
  final String telefono;
  final String? correo;
  final String? municipio;
  final String? departamento;
  final String? direccionExacta;
  final bool esProductora;
  final String? fotoPerfil;
  final int? idiomaPreferidoID;
  final double promedioValoracion;

  Usuario({
    required this.usuarioID,
    required this.nombres,
    required this.apellidos,
    required this.telefono,
    this.correo,
    this.municipio,
    this.departamento,
    this.direccionExacta,
    required this.esProductora,
    this.fotoPerfil,
    this.idiomaPreferidoID,
    this.promedioValoracion = 0,
  });

  String get nombreCompleto => '$nombres $apellidos';

  String get iniciales {
    final n = nombres.isNotEmpty ? nombres[0] : '';
    final a = apellidos.isNotEmpty ? apellidos[0] : '';
    return '$n$a'.toUpperCase();
  }

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        usuarioID: json['usuarioID'],
        nombres: json['nombres'] ?? '',
        apellidos: json['apellidos'] ?? '',
        telefono: json['telefono'] ?? '',
        correo: json['correo'],
        municipio: json['municipio'],
        departamento: json['departamento'],
        direccionExacta: json['direccionExacta'],
        esProductora: json['esProductora'] ?? true,
        fotoPerfil: json['fotoPerfil'],
        idiomaPreferidoID: json['idiomaPreferidoID'],
        promedioValoracion: (json['promedioValoracion'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'usuarioID': usuarioID,
        'nombres': nombres,
        'apellidos': apellidos,
        'telefono': telefono,
        'correo': correo,
        'municipio': municipio,
        'departamento': departamento,
        'direccionExacta': direccionExacta,
        'esProductora': esProductora,
        'fotoPerfil': fotoPerfil,
        'idiomaPreferidoID': idiomaPreferidoID,
        'promedioValoracion': promedioValoracion,
      };
}