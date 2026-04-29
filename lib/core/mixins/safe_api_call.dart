import 'package:dartz/dartz.dart';

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
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
