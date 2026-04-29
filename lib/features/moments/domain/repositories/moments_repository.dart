import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/moment_entity.dart';

abstract class MomentsRepository {
  Future<Either<Failure, List<MomentEntity>>> getMoments({int page = 0});
  Future<Either<Failure, MomentEntity>> likeMoment(String momentId);
}
