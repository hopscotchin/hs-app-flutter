import 'package:equatable/equatable.dart';

import '../constants/default_error_messages.dart';
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
    super.message = DefaultErrorMessages.timeout,
    super.statusCode,
  });
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({
    super.message = DefaultErrorMessages.connection,
  });
}

class RequestCancelledFailure extends Failure {
  const RequestCancelledFailure({
    super.message = DefaultErrorMessages.requestCancelled,
  });
}

// ─── HTTP status code failures ──────────────────────────────────────

class BadRequestFailure extends Failure {
  const BadRequestFailure({
    super.message = DefaultErrorMessages.badRequest,
    super.statusCode = 400,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = DefaultErrorMessages.unauthorized,
    super.statusCode = 401,
  });
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = DefaultErrorMessages.forbidden,
    super.statusCode = 403,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = DefaultErrorMessages.notFound,
    super.statusCode = 404,
  });
}

class ConflictFailure extends Failure {
  const ConflictFailure({
    super.message = DefaultErrorMessages.conflict,
    super.statusCode = 409,
  });
}

class InternalServerFailure extends Failure {
  const InternalServerFailure({
    super.message = DefaultErrorMessages.internalServer,
    super.statusCode = 500,
  });
}

class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure({
    super.message = DefaultErrorMessages.serviceUnavailable,
    super.statusCode = 503,
  });
}

// ─── API-level failures ─────────────────────────────────────────────

class ApiFailure extends Failure {
  final List<MessageBarEntity> messageBars;

  const ApiFailure({
    super.message = DefaultErrorMessages.api,
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
  const NetworkFailure({super.message = DefaultErrorMessages.network});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = DefaultErrorMessages.unknown});
}
