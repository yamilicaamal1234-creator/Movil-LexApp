import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/backend_models.dart';

class BackendRepository {
  BackendRepository(this.api);
  final ApiClient api;

  Future<BackendUser?> login({
    required String email,
    required String password,
  }) async {
    final response = await api.dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    final data = _map(response.data);
    final token = data['access_token']?.toString() ?? data['token']?.toString();
    if (token != null) await api.saveToken(token);
    final user = data['user'];
    return user is Map ? BackendUser.fromJson(_map(user)) : null;
  }

  Future<BackendUser?> register({
    required String email,
    required String password,
    required String tipoUsuario,
  }) async {
    final response = await api.dio.post(
      '/auth/register',
      data: {
        'email': email,
        'password_hash': password,
        'tipo_usuario': tipoUsuario,
      },
    );
    final data = _map(response.data);
    final token = data['access_token']?.toString() ?? data['token']?.toString();
    if (token != null) await api.saveToken(token);
    final user = data['user'];
    return user is Map ? BackendUser.fromJson(_map(user)) : null;
  }

  Future<List<BackendCase>> getCases() async {
    final response = await api.dio.get('/casos');
    return _list(
      response.data,
    ).map((item) => BackendCase.fromJson(_map(item))).toList();
  }

  Future<List<BackendMessage>> getMessages(int caseId) async {
    final response = await api.dio.get('/casos/$caseId/mensajes');
    return _list(
      response.data,
    ).map((item) => BackendMessage.fromJson(_map(item))).toList();
  }

  Future<BackendMessage?> sendMessage(int caseId, String text) async {
    final response = await api.dio.post(
      '/casos/$caseId/mensajes',
      data: {'mensaje_texto': text},
    );
    return BackendMessage.fromJson(_map(response.data));
  }

  Future<List<BackendDocument>> getDocuments(int caseId) async {
    final response = await api.dio.get('/casos/$caseId/documentos');
    return _list(
      response.data,
    ).map((item) => BackendDocument.fromJson(_map(item))).toList();
  }

  Future<BackendDocument> uploadDocument({
    required int caseId,
    required String filePath,
    required String fileName,
    String? tipoDocumento,
  }) async {
    final formData = FormData.fromMap({
      'archivo': await MultipartFile.fromFile(filePath, filename: fileName),
      if (tipoDocumento != null) 'tipo_documento': tipoDocumento,
    });
    final response = await api.dio.post(
      '/casos/$caseId/documentos',
      data: formData,
    );
    return BackendDocument.fromJson(_map(response.data));
  }

  Future<void> logout() => api.clearSession();

  static Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is List && value.isNotEmpty && value.first is Map) {
      return Map<String, dynamic>.from(value.first as Map);
    }
    return {};
  }

  static List<dynamic> _list(dynamic value) {
    if (value is List) return value;
    if (value is Map) {
      final candidates = ['data', 'items', 'results'];
      for (final key in candidates) {
        final nested = value[key];
        if (nested is List) return nested;
      }
    }
    return const [];
  }
}
