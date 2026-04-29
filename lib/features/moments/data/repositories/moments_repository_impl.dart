import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/moment_entity.dart';
import '../../domain/repositories/moments_repository.dart';
import '../datasources/remote/moments_remote_datasource.dart';

class MomentsRepositoryImpl with SafeApiCall implements MomentsRepository {
  final MomentsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MomentsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MomentEntity>>> getMoments({int page = 0}) {
    return safeApiCall(
      networkInfo,
      () async {
        final result = await remoteDataSource.getMoments(page: page);
        return result.moments;
      },
    );
  }

  @override
  Future<Either<Failure, MomentEntity>> likeMoment(String momentId) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.likeMoment(momentId),
    );
  }
}
