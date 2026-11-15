class BackendUser {
  final int idUsuario;
  final String email;
  final String tipoUsuario;
  final bool estaActivo;
  final bool emailVerificado;

  const BackendUser({
    required this.idUsuario,
    required this.email,
    required this.tipoUsuario,
    required this.estaActivo,
    required this.emailVerificado,
  });

  factory BackendUser.fromJson(Map<String, dynamic> json) => BackendUser(
    idUsuario: _int(json['id_usuario']),
    email: _string(json['email']),
    tipoUsuario: _string(json['tipo_usuario']),
    estaActivo: json['esta_activo'] == true,
    emailVerificado: json['email_verificado'] == true,
  );
}

class BackendClient {
  final int idCliente;
  final int idUsuario;
  final String primerNombre;
  final String? segundoNombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String? telefono;
  final String? direccionResidencia;

  const BackendClient({
    required this.idCliente,
    required this.idUsuario,
    required this.primerNombre,
    this.segundoNombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    this.telefono,
    this.direccionResidencia,
  });

  String get fullName => [
    primerNombre,
    segundoNombre,
    apellidoPaterno,
    apellidoMaterno,
  ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' ');

  factory BackendClient.fromJson(Map<String, dynamic> json) => BackendClient(
    idCliente: _int(json['id_cliente']),
    idUsuario: _int(json['id_usuario']),
    primerNombre: _string(json['primer_nombre']),
    segundoNombre: _nullableString(json['segundo_nombre']),
    apellidoPaterno: _string(json['apellido_paterno']),
    apellidoMaterno: _string(json['apellido_materno']),
    telefono: _nullableString(json['telefono']),
    direccionResidencia: _nullableString(json['direccion_residencia']),
  );
}

class BackendCase {
  final int idCaso;
  final String titulo;
  final String? descripcion;
  final String estadoCaso;
  final int? costoTotalCentavos;

  const BackendCase({
    required this.idCaso,
    required this.titulo,
    this.descripcion,
    required this.estadoCaso,
    this.costoTotalCentavos,
  });

  factory BackendCase.fromJson(Map<String, dynamic> json) => BackendCase(
    idCaso: _int(json['id_caso']),
    titulo: _string(json['titulo']),
    descripcion: _nullableString(json['descripcion']),
    estadoCaso: _string(json['estado_caso']),
    costoTotalCentavos: json['costo_total_centavos'] == null
        ? null
        : _int(json['costo_total_centavos']),
  );
}

class BackendMessage {
  final int idMensaje;
  final int idCaso;
  final int idRemitente;
  final String mensajeTexto;
  final DateTime fechaHora;

  const BackendMessage({
    required this.idMensaje,
    required this.idCaso,
    required this.idRemitente,
    required this.mensajeTexto,
    required this.fechaHora,
  });

  factory BackendMessage.fromJson(Map<String, dynamic> json) => BackendMessage(
    idMensaje: _int(json['id_mensaje']),
    idCaso: _int(json['id_caso']),
    idRemitente: _int(json['id_remitente']),
    mensajeTexto: _string(json['mensaje_texto']),
    fechaHora:
        DateTime.tryParse(_string(json['fecha_hora']))?.toLocal() ??
        DateTime.now(),
  );
}

class BackendDocument {
  final int idDocumento;
  final int idCaso;
  final String nombreArchivo;
  final String rutaArchivo;
  final String? tipoDocumento;

  const BackendDocument({
    required this.idDocumento,
    required this.idCaso,
    required this.nombreArchivo,
    required this.rutaArchivo,
    this.tipoDocumento,
  });

  factory BackendDocument.fromJson(Map<String, dynamic> json) =>
      BackendDocument(
        idDocumento: _int(json['id_documento']),
        idCaso: _int(json['id_caso']),
        nombreArchivo: _string(json['nombre_archivo']),
        rutaArchivo: _string(json['ruta_archivo']),
        tipoDocumento: _nullableString(json['tipo_documento']),
      );
}

int _int(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _string(dynamic value) => value?.toString() ?? '';
String? _nullableString(dynamic value) => value?.toString();
