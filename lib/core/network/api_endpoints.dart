/// API Endpoints configuration for network services.
class ApiEndpoints {
  ApiEndpoints._();

  static const String defaultBaseUrl = 'http://192.168.29.186:5001';

  static String get baseUrl => const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: defaultBaseUrl,
  );

  static const String analyses = '/api/v1/analyses';
}
