import 'package:equatable/equatable.dart';

import '../entities/message_bar_entity.dart';

sealed class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

// ─── Network / HTTP failures ────────────────────────────────────────

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Uh-oh! Connection timed out. Please try again.',
    super.statusCode,
  });
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({
    super.message = 'Uh-oh! There seems to be no internet connection.',
  });
}

class RequestCancelledFailure extends Failure {
  const RequestCancelledFailure({
    super.message = 'Uh-oh! Request was cancelled.',
  });
}

// ─── HTTP status code failures ──────────────────────────────────────

class BadRequestFailure extends Failure {
  const BadRequestFailure({
    super.message = 'Invalid request. Please try again.',
    super.statusCode = 400,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Uh-oh! Session expired. Please log in again.',
    super.statusCode = 401,
  });
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'Uh-oh! You don\'t have permission to access this resource.',
    super.statusCode = 403,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Uh-oh! The requested resource was not found.',
    super.statusCode = 404,
  });
}

class ConflictFailure extends Failure {
  const ConflictFailure({
    super.message = 'Uh-oh! A conflict occurred. Please try again.',
    super.statusCode = 409,
  });
}

class InternalServerFailure extends Failure {
  const InternalServerFailure({
    super.message = 'Something went wrong on our end. Please try again later.',
    super.statusCode = 500,
  });
}

class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure({
    super.message = 'Service is temporarily unavailable. Please try again later.',
    super.statusCode = 503,
  });
}

// ─── API-level failures ─────────────────────────────────────────────

class ApiFailure extends Failure {
  final List<MessageBarEntity> messageBars;

  const ApiFailure({
    super.message = 'Request failed. Please try again.',
    super.statusCode,
    this.messageBars = const [],
  });

  @override
  List<Object?> get props => [message, statusCode, messageBars];
}

// ─── Other failures ─────────────────────────────────────────────────

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unknown error occurred.'});
}
