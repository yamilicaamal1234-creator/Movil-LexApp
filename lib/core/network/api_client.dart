import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final response = error.response;
          final data = response?.data;
          String message = error.message ?? 'Error de conexión';
          if (data is Map && data['message'] is String) {
            message = data['message'] as String;
          } else if (data is Map && data['error'] is String) {
            message = data['error'] as String;
          }
          handler.next(
            DioException(
              requestOptions: error.requestOptions,
              response: response,
              type: error.type,
              error: ApiException(message, statusCode: response?.statusCode),
            ),
          );
        },
      ),
    );
  }

  final FlutterSecureStorage _storage;
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  Future<void> saveToken(String token) =>
      _storage.write(key: 'access_token', value: token);
  Future<String?> getToken() => _storage.read(key: 'access_token');
  Future<void> clearSession() => _storage.delete(key: 'access_token');
}
