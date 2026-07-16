import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../constants/default_error_messages.dart';
import '../entities/message_bar_entity.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';
import '../logger/my_logger.dart';
import '../models/message_bar_model.dart';
import '../network/connectivity/network_info.dart';

mixin SafeApiCall {
  Future<Either<Failure, T>> safeApiCall<T>(
    NetworkInfo networkInfo,
    Future<T> Function() apiCall,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await apiCall();
      return Right(result);
    } on TimeoutException catch (e, s) {
      logger.w('API timeout', error: e, stackTrace: s);
      return Left(TimeoutFailure(message: e.message, statusCode: e.statusCode));
    } on RequestCancelledException {
      return const Left(RequestCancelledFailure());
    } on ConnectionException catch (e, s) {
      logger.w('No connection', error: e, stackTrace: s);
      return const Left(ConnectionFailure());
    } on UnauthorizedException catch (e, s) {
      logger.w('Unauthorized', error: e, stackTrace: s);
      return Left(UnauthorizedFailure(message: e.message));
    } on ForbiddenException catch (e, s) {
      logger.w('Forbidden', error: e, stackTrace: s);
      return Left(ForbiddenFailure(message: e.message));
    } on NotFoundException catch (e, s) {
      logger.w('Not found', error: e, stackTrace: s);
      return Left(NotFoundFailure(message: e.message));
    } on BadRequestException catch (e, s) {
      logger.w('Bad request', error: e, stackTrace: s);
      return Left(BadRequestFailure(message: e.message));
    } on ConflictException catch (e, s) {
      logger.w('Conflict', error: e, stackTrace: s);
      return Left(ConflictFailure(message: e.message));
    } on InternalServerException catch (e, s) {
      logger.e('Internal server error', error: e, stackTrace: s);
      return Left(InternalServerFailure(message: e.message));
    } on ServiceUnavailableException catch (e, s) {
      logger.e('Service unavailable', error: e, stackTrace: s);
      return Left(ServiceUnavailableFailure(message: e.message));
    } on ApiFailureException catch (e, s) {
      logger.w('API failure', error: e, stackTrace: s);
      final List<MessageBarEntity> bars = e.rawMessageBars
          .whereType<Map<String, dynamic>>()
          .map(MessageBarModel.fromJson)
          .toList();
      return Left(ApiFailure(message: e.message, messageBars: bars));
    } on ServerException catch (e, s) {
      logger.e('Server error', error: e, stackTrace: s);
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on AppException catch (e, s) {
      logger.e('App exception', error: e, stackTrace: s);
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.cancel) {
        logger.w('Dio cancel', error: e, stackTrace: s);
        return const Left(RequestCancelledFailure());
      }
      if (e.type == DioExceptionType.badResponse) {
        logger.w('Dio bad response [${e.response?.statusCode}]', error: e, stackTrace: s);
        return Left(_failureFromResponse(e.response));
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        logger.w('Dio timeout', error: e, stackTrace: s);
        return const Left(TimeoutFailure());
      }
      if (e.type == DioExceptionType.connectionError) {
        logger.w('Dio connection error', error: e, stackTrace: s);
        return const Left(ConnectionFailure());
      }

      logger.w('Dio unknown error', error: e, stackTrace: s);
      return const Left(UnknownFailure());
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  /// Extracts the server's `message` field from the response body and maps
  /// the HTTP status code to the appropriate [Failure] subtype.
  Failure _failureFromResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;
    final serverMessage = data is Map ? data['message'] as String? : null;

    return switch (statusCode) {
      400 => BadRequestFailure(message: serverMessage ?? DefaultErrorMessages.badRequest),
      401 => UnauthorizedFailure(message: serverMessage ?? DefaultErrorMessages.unauthorized),
      403 => ForbiddenFailure(message: serverMessage ?? DefaultErrorMessages.forbidden),
      404 => NotFoundFailure(message: serverMessage ?? DefaultErrorMessages.notFound),
      409 => ConflictFailure(message: serverMessage ?? DefaultErrorMessages.conflict),
      500 => InternalServerFailure(message: serverMessage ?? DefaultErrorMessages.internalServer),
      503 => ServiceUnavailableFailure(
        message: serverMessage ?? DefaultErrorMessages.serviceUnavailable,
      ),
      _ => ServerFailure(
        message: serverMessage ?? DefaultErrorMessages.unknown,
        statusCode: statusCode,
      ),
    };
  }
}
