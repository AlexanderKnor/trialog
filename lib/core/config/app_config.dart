import 'package:flutter/foundation.dart';

/// Application configuration
class AppConfig {
  final String apiBaseUrl;
  final String environment;
  final bool enableLogging;
  final Duration apiTimeout;

  const AppConfig({
    required this.apiBaseUrl,
    required this.environment,
    required this.enableLogging,
    required this.apiTimeout,
  });

  /// Development configuration
  factory AppConfig.development() {
    return const AppConfig(
      apiBaseUrl: 'http://localhost:3000/api/v1',
      environment: 'development',
      enableLogging: true,
      apiTimeout: Duration(seconds: 30),
    );
  }

  /// Staging configuration
  factory AppConfig.staging() {
    return const AppConfig(
      apiBaseUrl: 'https://staging-api.trialog.com/api/v1',
      environment: 'staging',
      enableLogging: true,
      apiTimeout: Duration(seconds: 30),
    );
  }

  /// Production configuration
  factory AppConfig.production() {
    return const AppConfig(
      apiBaseUrl: 'https://api.trialog.com/api/v1',
      environment: 'production',
      enableLogging: false,
      apiTimeout: Duration(seconds: 30),
    );
  }

  /// Get current configuration based on build mode
  factory AppConfig.current() {
    if (kDebugMode) {
      return AppConfig.development();
    } else if (kProfileMode) {
      return AppConfig.staging();
    } else {
      return AppConfig.production();
    }
  }

  bool get isDevelopment => environment == 'development';
  bool get isStaging => environment == 'staging';
  bool get isProduction => environment == 'production';
}
