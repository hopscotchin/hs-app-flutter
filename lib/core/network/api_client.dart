import 'dart:async';

import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import 'models/action_response.dart';

class ApiClient {
  final Dio _dio;

  /// Max retries for idempotent requests (GET only).
  static const int _maxRetries = 2;

  /// Initial backoff duration between retries.
  static const Duration _initialBackoff = Duration(milliseconds: 500);

  ApiClient({required Dio dio}) : _dio = dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
    int? maxRetries,
  }) {
    return _executeWithRetry(
      () => _execute(
        () => _dio.get(
          path,
          queryParameters: queryParameters,
          options: _applyTimeout(options, timeout),
          cancelToken: cancelToken,
        ),
      ),
      maxRetries: maxRetries ?? _maxRetries,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
  }) {
    return _execute(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _applyTimeout(options, timeout),
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
  }) {
    return _execute(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _applyTimeout(options, timeout),
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Duration? timeout,
  }) {
    return _execute(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _applyTimeout(options, timeout),
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response> _execute(Future<Response> Function() request) async {
    try {
      final response = await request();
      _validateActionResponse(response);
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response> _executeWithRetry(
    Future<Response> Function() request, {
    int maxRetries = _maxRetries,
  }) async {
    var attempt = 0;
    while (true) {
      try {
        return await request();
      } on AppException catch (e) {
        attempt++;
        final isRetryable =
            e is TimeoutException ||
            (e.statusCode != null && e.statusCode! >= 500);
        if (!isRetryable || attempt > maxRetries) rethrow;
        await Future.delayed(_initialBackoff * attempt);
      }
    }
  }

  void _validateActionResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      ActionResponse.validate(data);
    }
  }

  Options _applyTimeout(Options? options, Duration? timeout) {
    final opts = options ?? Options();
    if (timeout != null) {
      opts.sendTimeout = timeout;
      opts.receiveTimeout = timeout;
    }
    return opts;
  }

  AppException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(statusCode: e.response?.statusCode);
      case DioExceptionType.cancel:
        return const RequestCancelledException();
      case DioExceptionType.connectionError:
        return const ConnectionException();
      case DioExceptionType.badResponse:
        return _mapStatusCode(e);
      default:
        return ServerException(
          message:
              e.message ??
              'Uh-oh! Our systems are acting up. Please try again later.',
          statusCode: e.response?.statusCode,
        );
    }
  }

  AppException _mapStatusCode(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    final message = data is Map ? data['message'] as String? : null;

    return switch (statusCode) {
      400 => BadRequestException(
        message:
            message ??
            'Uh-oh! Our systems are acting up. Please try again later.',
      ),
      401 => UnauthorizedException(
        message: message ?? 'Uh-oh! Session expired. Please log in again.',
      ),
      403 => ForbiddenException(
        message:
            message ??
            'Uh-oh! You don\'t have permission to access this resource.',
      ),
      404 => NotFoundException(
        message: message ?? 'Uh-oh! The requested resource was not found.',
      ),
      409 => ConflictException(
        message: message ?? 'Uh-oh! A conflict occurred. Please try again.',
      ),
      500 => InternalServerException(
        message:
            message ??
            'Uh-oh! Our systems are acting up. Please try again later.',
      ),
      503 => ServiceUnavailableException(
        message:
            message ??
            'Uh-oh! Service is temporarily unavailable. Please try again later.',
      ),
      _ => ServerException(
        message:
            message ??
            'Uh-oh! Our systems are acting up. Please try again later.',
        statusCode: statusCode,
      ),
    };
  }
}
