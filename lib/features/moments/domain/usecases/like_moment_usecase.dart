import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/moment_entity.dart';
import '../repositories/moments_repository.dart';

class LikeMomentUseCase implements UseCase<MomentEntity, LikeMomentParams> {
  final MomentsRepository repository;

  LikeMomentUseCase(this.repository);

  @override
  Future<Either<Failure, MomentEntity>> call(LikeMomentParams params) {
    return repository.likeMoment(params.momentId);
  }
}

class LikeMomentParams extends Equatable {
  final String momentId;

  const LikeMomentParams({required this.momentId});

  @override
  List<Object?> get props => [momentId];
}
