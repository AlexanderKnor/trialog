/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Trialog';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String apiBaseUrl = ''; // TODO: Set production API URL
  static const Duration apiTimeout = Duration(seconds: 30);

  // Local Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Duration
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(minutes: 30);
  static const Duration longCacheDuration = Duration(hours: 24);
}
