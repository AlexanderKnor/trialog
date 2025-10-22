import 'package:dio/dio.dart';
import 'package:trialog/core/config/app_config.dart';
import 'package:trialog/core/errors/exceptions.dart';

/// HTTP service for API communication
class HttpService {
  final Dio _dio;
  final AppConfig _config;

  HttpService(this._config) : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: _config.apiBaseUrl,
      connectTimeout: _config.apiTimeout,
      receiveTimeout: _config.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (_config.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  /// Set authentication token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authentication token
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PATCH request
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle response
  T _handleResponse<T>(Response response) {
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw ServerException(
        message: 'Request failed with status: ${response.statusCode}',
        code: response.statusCode,
        details: response.data,
      );
    }

    return response.data as T;
  }

  /// Handle Dio errors
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: 'Connection timeout',
          details: error.message,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        if (statusCode == 401) {
          return AuthenticationException(
            message: 'Authentication failed',
            code: statusCode,
            details: data,
          );
        } else if (statusCode == 403) {
          return AuthorizationException(
            message: 'Access forbidden',
            code: statusCode,
            details: data,
          );
        } else if (statusCode == 404) {
          return NotFoundException(
            message: 'Resource not found',
            code: statusCode,
            details: data,
          );
        } else if (statusCode == 409) {
          return ConflictException(
            message: 'Resource conflict',
            code: statusCode,
            details: data,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: 'Server error',
            code: statusCode,
            details: data,
          );
        } else {
          return ServerException(
            message: 'Request failed',
            code: statusCode,
            details: data,
          );
        }

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'No internet connection',
        );

      case DioExceptionType.cancel:
        return const ServerException(
          message: 'Request cancelled',
        );

      default:
        return ServerException(
          message: 'Unexpected error: ${error.message}',
          details: error.error,
        );
    }
  }
}
