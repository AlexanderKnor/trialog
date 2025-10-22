/// Base class for all exceptions in the application
class AppException implements Exception {
  final String message;
  final int? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Network connection exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Authentication exceptions
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Authorization exceptions
class AuthorizationException extends AppException {
  const AuthorizationException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Not found exceptions (404)
class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Conflict exceptions (409)
class ConflictException extends AppException {
  const ConflictException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Timeout exceptions
class TimeoutException extends AppException {
  const TimeoutException({
    required super.message,
    super.code,
    super.details,
  });
}
