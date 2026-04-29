sealed class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => '$runtimeType: $message (status: $statusCode)';
}

// ─── Network / HTTP exceptions ──────────────────────────────────────

class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Uh-oh! Connection timed out. Please try again.',
    super.statusCode,
  });
}

class ConnectionException extends AppException {
  const ConnectionException({
    super.message = 'Unable to connect. Check your internet connection.',
  });
}

class RequestCancelledException extends AppException {
  const RequestCancelledException({
    super.message = 'Uh-oh! Request was cancelled.',
  });
}

// ─── HTTP status code exceptions ────────────────────────────────────

class BadRequestException extends AppException {
  const BadRequestException({
    super.message = 'Uh-oh! Invalid request. Please try again.',
    super.statusCode = 400,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Uh-oh! Session expired. Please log in again.',
    super.statusCode = 401,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Uh-oh! You don\'t have permission to access this resource.',
    super.statusCode = 403,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Uh-oh! The requested resource was not found.',
    super.statusCode = 404,
  });
}

class ConflictException extends AppException {
  const ConflictException({
    super.message = 'Uh-oh! A conflict occurred. Please try again.',
    super.statusCode = 409,
  });
}

class InternalServerException extends AppException {
  const InternalServerException({
    super.message = 'Uh-oh! Our systems are acting up. Please try again later.',
    super.statusCode = 500,
  });
}

class ServiceUnavailableException extends AppException {
  const ServiceUnavailableException({
    super.message = 'Uh-oh! Service is temporarily unavailable. Please try again later.',
    super.statusCode = 503,
  });
}

// ─── API-level exceptions ───────────────────────────────────────────

class ApiFailureException extends AppException {
  final List<dynamic> rawMessageBars;

  const ApiFailureException({
    super.message = 'Uh-oh! Our systems are acting up. Please try again later.',
    super.statusCode,
    this.rawMessageBars = const [],
  });
}

// ─── Other exceptions ───────────────────────────────────────────────

class CacheException extends AppException {
  const CacheException({super.message = 'Uh-oh! Cache error occurred.'});
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'Uh-oh! There seems to be no internet connection.'});
}
