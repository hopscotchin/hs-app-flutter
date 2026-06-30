import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../constants/default_error_messages.dart';
import '../entities/message_bar_entity.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';
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
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(message: e.message, statusCode: e.statusCode));
    } on RequestCancelledException {
      return const Left(RequestCancelledFailure());
    } on ConnectionException {
      return const Left(ConnectionFailure());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ForbiddenException catch (e) {
      return Left(ForbiddenFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(BadRequestFailure(message: e.message));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(message: e.message));
    } on InternalServerException catch (e) {
      return Left(InternalServerFailure(message: e.message));
    } on ServiceUnavailableException catch (e) {
      return Left(ServiceUnavailableFailure(message: e.message));
    } on ApiFailureException catch (e) {
      final List<MessageBarEntity> bars = e.rawMessageBars
          .whereType<Map<String, dynamic>>()
          .map(MessageBarModel.fromJson)
          .toList();
      return Left(ApiFailure(message: e.message, messageBars: bars));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        return const Left(RequestCancelledFailure());
      }
      if (e.type == DioExceptionType.badResponse) {
        return Left(_failureFromResponse(e.response));
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(TimeoutFailure());
      }
      if (e.type == DioExceptionType.connectionError) {
        return const Left(ConnectionFailure());
      }

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
