class AppConstants {
  AppConstants._();

  /// Toggle between mock data and live API.
  /// Run with: flutter run --dart-define=USE_MOCK=false
  static const bool useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);

  /// Base URL for the Laravel API.
  /// Run with: flutter run --dart-define=BASE_URL=https://your-api.com
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8001/api/v1', // Android emulator → localhost
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String tokenKey = 'nh_auth_token';
  static const String userKey  = 'nh_auth_user';
}
