import 'dart:developer' as developer;

/// Application logger utility
class Logger {
  Logger._();

  static const String _defaultTag = 'Trialog';

  /// Log debug message
  static void debug(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? _defaultTag,
      level: 500,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log info message
  static void info(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? _defaultTag,
      level: 800,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log warning message
  static void warning(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? _defaultTag,
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log error message
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? _defaultTag,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
