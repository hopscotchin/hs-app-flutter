import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/moment_entity.dart';
import '../repositories/moments_repository.dart';

class GetMomentsUseCase
    implements UseCase<List<MomentEntity>, GetMomentsParams> {
  final MomentsRepository repository;

  GetMomentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<MomentEntity>>> call(GetMomentsParams params) {
    return repository.getMoments(page: params.page);
  }
}

class GetMomentsParams extends Equatable {
  final int page;

  const GetMomentsParams({this.page = 0});

  @override
  List<Object?> get props => [page];
}
