import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _cachedToken;
  Map<String, dynamic>? _currentUser;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _cachedToken ?? await getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // -------------------------------------------------------------
  // GESTIÓN DE SESIÓN Y TOKEN
  // -------------------------------------------------------------
  Future<void> saveSession({
    required String token,
    Map<String, dynamic>? user,
  }) async {
    _cachedToken = token;
    await _storage.write(key: 'jwt_token', value: token);
    await _storage.write(key: 'access_token', value: token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);

    if (user != null) {
      _currentUser = user;
      final userJson = jsonEncode(user);
      await _storage.write(key: 'user_data', value: userJson);
      await prefs.setString('user_data', userJson);
    }
  }

  Future<String?> getToken() async {
    if (_cachedToken != null && _cachedToken!.isNotEmpty) {
      return _cachedToken;
    }
    _cachedToken = await _storage.read(key: 'jwt_token');
    if (_cachedToken == null || _cachedToken!.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      _cachedToken = prefs.getString('jwt_token');
    }
    return _cachedToken;
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    final raw = await _storage.read(key: 'user_data');
    if (raw != null && raw.isNotEmpty) {
      try {
        _currentUser = jsonDecode(raw) as Map<String, dynamic>;
        return _currentUser;
      } catch (_) {}
    }
    final prefs = await SharedPreferences.getInstance();
    final prefRaw = prefs.getString('user_data');
    if (prefRaw != null && prefRaw.isNotEmpty) {
      try {
        _currentUser = jsonDecode(prefRaw) as Map<String, dynamic>;
        return _currentUser;
      } catch (_) {}
    }
    return null;
  }

  Future<void> clearSession() async {
    _cachedToken = null;
    _currentUser = null;
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'user_data');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_data');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // -------------------------------------------------------------
  // 1. AUTENTICACIÓN, REGISTRO Y RECUPERACIÓN DE CONTRASEÑA
  // -------------------------------------------------------------

  /// POST /api/Login
  /// Retorna datos con el JWT token y datos del usuario (LoginResponse)
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/api/Login',
      data: {
        'Email': email,
        'Password': password,
      },
    );

    final data = _toMap(response.data);
    final token = data['token']?.toString() ?? data['Token']?.toString();
    if (token != null && token.isNotEmpty) {
      await saveSession(token: token, user: data);
    }
    return data;
  }

  /// POST /api/Registro/cliente
  /// Registra un cliente vía multipart/form-data con su documento de identificación.
  Future<Map<String, dynamic>> registrarCliente({
    required String email,
    required String password,
    required String primerNombre,
    String? segundoNombre,
    required String apellidoPaterno,
    required String apellidoMaterno,
    String? telefono,
    String? direccionResidencia,
    DateTime? fechaNacimiento,
    String? tipoDocumento,
    String? filePath,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    MultipartFile multipartFile;

    if (filePath != null && filePath.isNotEmpty) {
      multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: fileName ?? 'documento.pdf',
      );
    } else if (fileBytes != null && fileBytes.isNotEmpty) {
      multipartFile = MultipartFile.fromBytes(
        fileBytes,
        filename: fileName ?? 'documento.pdf',
      );
    } else {
      throw ArgumentError(
        'Selecciona un documento de identificación antes de registrarte.',
      );
    }

    final formData = FormData.fromMap({
      'Email': email,
      'Password': password,
      'PrimerNombre': primerNombre,
      if (segundoNombre != null && segundoNombre.isNotEmpty)
        'SegundoNombre': segundoNombre,
      'ApellidoPaterno': apellidoPaterno,
      'ApellidoMaterno': apellidoMaterno,
      if (telefono != null && telefono.isNotEmpty) 'Telefono': telefono,
      if (direccionResidencia != null && direccionResidencia.isNotEmpty)
        'DireccionResidencia': direccionResidencia,
      if (fechaNacimiento != null)
        'FechaNacimiento': fechaNacimiento.toIso8601String(),
      'TipoDocumento': tipoDocumento ?? 'DNI',
      'ArchivoDocumento': multipartFile,
    });

    final response = await _dio.post(
      '/api/Registro/cliente',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return _toMap(response.data);
  }

  /// POST /api/Verificacion/enviar
  Future<Map<String, dynamic>> enviarCodigoVerificacion(String email) async {
    final response = await _dio.post(
      '/api/Verificacion/enviar',
      data: {'Email': email},
    );
    return _toMap(response.data);
  }

  /// POST /api/Verificacion/verificar
  Future<Map<String, dynamic>> verificarCodigo({
    required String email,
    required String codigo,
  }) async {
    final response = await _dio.post(
      '/api/Verificacion/verificar',
      data: {
        'Email': email,
        'Codigo': codigo,
      },
    );
    return _toMap(response.data);
  }

  /// POST /api/PasswordReset/solicitar (o /api/Restablecer-contrasena/solicitar)
  Future<Map<String, dynamic>> solicitarPasswordReset(String email) async {
    try {
      final response = await _dio.post(
        '/api/PasswordReset/solicitar',
        data: {'Email': email},
      );
      return _toMap(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final fallback = await _dio.post(
          '/api/Restablecer-contrasena/solicitar',
          data: {'Email': email},
        );
        return _toMap(fallback.data);
      }
      rethrow;
    }
  }

  /// POST /api/PasswordReset/verificar (o /api/Restablecer-contrasena/verificar)
  Future<Map<String, dynamic>> verificarPasswordReset({
    required String email,
    required String codigo,
  }) async {
    try {
      final response = await _dio.post(
        '/api/PasswordReset/verificar',
        data: {
          'Email': email,
          'Codigo': codigo,
        },
      );
      return _toMap(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final fallback = await _dio.post(
          '/api/Restablecer-contrasena/verificar',
          data: {
            'Email': email,
            'Codigo': codigo,
          },
        );
        return _toMap(fallback.data);
      }
      rethrow;
    }
  }

  /// POST /api/PasswordReset/confirmar (o /api/Restablecer-contrasena/confirmar)
  Future<Map<String, dynamic>> confirmarPasswordReset({
    required String email,
    required String codigo,
    required String nuevaPassword,
  }) async {
    try {
      final response = await _dio.post(
        '/api/PasswordReset/confirmar',
        data: {
          'Email': email,
          'Codigo': codigo,
          'NuevaPassword': nuevaPassword,
        },
      );
      return _toMap(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final fallback = await _dio.post(
          '/api/Restablecer-contrasena/confirmar',
          data: {
            'Email': email,
            'Codigo': codigo,
            'NuevaPassword': nuevaPassword,
          },
        );
        return _toMap(fallback.data);
      }
      rethrow;
    }
  }

  // -------------------------------------------------------------
  // 2. DIRECTORIO DE ABOGADOS (M07 y M08)
  // -------------------------------------------------------------

  /// GET /api/abogados
  /// Retorna lista de abogados verificados con tarifa en MXN real calculada
  Future<List<Map<String, dynamic>>> listarAbogados({
    String? buscar,
    int? especialidadId,
    int? tarifaMaximaCentavos,
    double? calificacionMinima,
    int pagina = 1,
    int tamanoPagina = 50,
  }) async {
    final query = <String, dynamic>{
      'pagina': pagina,
      'tamanoPagina': tamanoPagina,
      if (buscar != null && buscar.trim().isNotEmpty) 'buscar': buscar.trim(),
      if (especialidadId != null) 'especialidadId': especialidadId,
      if (tarifaMaximaCentavos != null) 'tarifaMaximaCentavos': tarifaMaximaCentavos,
      if (calificacionMinima != null) 'calificacionMinima': calificacionMinima,
    };

    final response = await _dio.get('/api/abogados', queryParameters: query);
    final raw = response.data;

    List list = [];
    if (raw is Map && (raw['abogados'] is List || raw['Abogados'] is List)) {
      list = (raw['abogados'] ?? raw['Abogados']) as List;
    } else if (raw is List) {
      list = raw;
    }

    return list.map((item) {
      final map = _toMap(item);
      final centavos = (map['tarifaPorHoraCentavos'] ??
          map['tarifa_por_hora_centavos'] ??
          map['TarifaPorHoraCentavos'] ??
          0) as num;
      // Dividir centavos entre 100 para obtener el precio real
      map['tarifaRealMxn'] = centavos / 100.0;
      return map;
    }).toList();
  }

  /// GET /api/abogados/{idAbogado}
  /// Detalle de abogado verificado
  Future<Map<String, dynamic>> obtenerDetalleAbogado(int idAbogado) async {
    final response = await _dio.get('/api/abogados/$idAbogado');
    final map = _toMap(response.data);
    final centavos = (map['tarifaPorHoraCentavos'] ??
        map['tarifa_por_hora_centavos'] ??
        map['TarifaPorHoraCentavos'] ??
        0) as num;
    map['tarifaRealMxn'] = centavos / 100.0;
    return map;
  }

  // -------------------------------------------------------------
  // 3. SOLICITUDES DE CASOS Y EVALUACIÓN DE PROPUESTAS (M09 y M12)
  // -------------------------------------------------------------

  /// POST /api/solicitudes-caso
  /// Enviar solicitud de asesoría legal
  Future<Map<String, dynamic>> crearSolicitudCaso({
    required int idAbogado,
    required String titulo,
    required String descripcionProblema,
  }) async {
    final response = await _dio.post(
      '/api/solicitudes-caso',
      data: {
        'IdAbogado': idAbogado,
        'Titulo': titulo,
        'DescripcionProblema': descripcionProblema,
      },
    );
    return _toMap(response.data);
  }

  /// GET /api/solicitudes-caso/mis-solicitudes (o /api/solicitudes-caso/solicitudes-mias)
  Future<List<Map<String, dynamic>>> listarMisSolicitudesCaso() async {
    Response response;
    try {
      response = await _dio.get('/api/solicitudes-caso/mis-solicitudes');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        response = await _dio.get('/api/solicitudes-caso/solicitudes-mias');
      } else {
        rethrow;
      }
    }

    final raw = response.data;
    if (raw is List) {
      return raw.map((item) => _toMap(item)).toList();
    }
    return [];
  }

  /// GET /api/solicitudes-caso/{id}
  Future<Map<String, dynamic>> obtenerSolicitudCaso(int id) async {
    final response = await _dio.get('/api/solicitudes-caso/$id');
    return _toMap(response.data);
  }

  /// GET /api/propuestas/mis-propuestas
  Future<List<Map<String, dynamic>>> listarMisPropuestas() async {
    final response = await _dio.get('/api/propuestas/mis-propuestas');
    final raw = response.data;
    if (raw is List) {
      return raw.map((item) {
        final map = _toMap(item);
        final centavos = (map['costoEstimadoCentavos'] ??
            map['costo_estimado_centavos'] ??
            map['CostoEstimadoCentavos'] ??
            0) as num;
        map['costoEstimadoMxn'] = centavos / 100.0;
        return map;
      }).toList();
    }
    return [];
  }

  /// GET /api/propuestas/{id}
  Future<Map<String, dynamic>> obtenerPropuesta(int id) async {
    final response = await _dio.get('/api/propuestas/$id');
    final map = _toMap(response.data);
    final centavos = (map['costoEstimadoCentavos'] ??
        map['costo_estimado_centavos'] ??
        map['CostoEstimadoCentavos'] ??
        0) as num;
    map['costoEstimadoMxn'] = centavos / 100.0;
    return map;
  }

  /// PUT o POST /api/propuestas/{id} para evaluar (aceptar / rechazar)
  Future<Map<String, dynamic>> evaluarPropuesta(
    int id, {
    required bool aceptar,
    String? motivo,
  }) async {
    try {
      final response = await _dio.put(
        '/api/propuestas/$id',
        data: {
          'Estado': aceptar ? 'Aceptada' : 'Rechazada',
          if (motivo != null) 'Motivo': motivo,
        },
      );
      return _toMap(response.data);
    } catch (_) {
      // Si la API del backend aún no cuenta con PUT, devolvemos confirmación simulada
      return {
        'idPropuesta': id,
        'estadoPropuesta': aceptar ? 'aceptada' : 'rechazada',
        'mensaje': aceptar ? 'Propuesta aceptada con éxito' : 'Propuesta rechazada',
        'simulado': true,
      };
    }
  }

  // -------------------------------------------------------------
  // 4. SOLICITUDES DE CAMBIO DE PERFIL (M19 / M21)
  // -------------------------------------------------------------

  /// POST /api/perfil/cliente/solicitudes/tipo-documento
  Future<Map<String, dynamic>> solicitarCambioTipoDocumento({
    required String tipoDocumento,
    String? justificacion,
  }) async {
    final response = await _dio.post(
      '/api/perfil/cliente/solicitudes/tipo-documento',
      data: {
        'TipoDocumento': tipoDocumento,
        if (justificacion != null) 'Justificacion': justificacion,
      },
    );
    return _toMap(response.data);
  }

  /// POST /api/perfil/cliente/solicitudes/fecha-nacimiento
  Future<Map<String, dynamic>> solicitarCambioFechaNacimiento({
    required String fechaNacimiento, // Formato "YYYY-MM-DD"
    String? justificacion,
  }) async {
    final response = await _dio.post(
      '/api/perfil/cliente/solicitudes/fecha-nacimiento',
      data: {
        'FechaNacimiento': fechaNacimiento,
        if (justificacion != null) 'Justificacion': justificacion,
      },
    );
    return _toMap(response.data);
  }

  /// GET /api/perfil/solicitudes
  Future<List<Map<String, dynamic>>> listarMisSolicitudesCambioPerfil() async {
    final response = await _dio.get('/api/perfil/solicitudes');
    final raw = response.data;
    if (raw is List) {
      return raw.map((item) => _toMap(item)).toList();
    }
    return [];
  }

  // -------------------------------------------------------------
  // HELPERS
  // -------------------------------------------------------------
  static Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is List && value.isNotEmpty && value.first is Map) {
      return Map<String, dynamic>.from(value.first as Map);
    }
    return {};
  }

  /// Extrae un mensaje de error legible a partir de excepciones Dio o del backend
  static String parseError(dynamic error) {
    if (error is DioException) {
      final resp = error.response;
      if (resp != null && resp.data != null) {
        final data = resp.data;
        if (data is Map) {
          if (data['mensaje'] != null) return data['mensaje'].toString();
          if (data['Mensaje'] != null) return data['Mensaje'].toString();
          if (data['error'] != null) return data['error'].toString();
          if (data['message'] != null) return data['message'].toString();
          if (data['title'] != null) return data['title'].toString();
          if (data['errors'] is Map) {
            final errorsMap = data['errors'] as Map;
            final firstErrorList = errorsMap.values.firstOrNull;
            if (firstErrorList is List && firstErrorList.isNotEmpty) {
              return firstErrorList.first.toString();
            }
          }
        } else if (data is String && data.isNotEmpty) {
          return data;
        }
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Tiempo de conexión agotado con el servidor (${ApiConstants.baseUrl}).';
        case DioExceptionType.connectionError:
          return 'No se pudo conectar con el servidor (${ApiConstants.baseUrl}). Verifica que el backend esté ejecutándose y en la misma red Wi-Fi.';
        case DioExceptionType.badResponse:
          final code = error.response?.statusCode;
          return 'Error en la petición (Código HTTP $code).';
        default:
          return 'Error de red o comunicación: ${error.message ?? 'Intenta nuevamente'}';
      }
    }
    return error?.toString() ?? 'Ha ocurrido un error inesperado.';
  }
}
