import '../constants/api_constants.dart';

class ApiConfig {
  ApiConfig._();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: ApiConstants.baseUrl,
  );
}
